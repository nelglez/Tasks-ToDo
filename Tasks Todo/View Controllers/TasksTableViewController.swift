//
//  TasksTableViewController.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreData

class TasksTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchedRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let todo = todos {
            let predicate = NSPredicate(format: "todo == %@", todo)
            
            fetchedRequest.predicate = predicate
        }
        
        fetchedRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        fetchedRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: moc, sectionNameKeyPath: "priority", cacheName: nil)
        
        fetchedResultController.delegate = self
        
        try! fetchedResultController.performFetch()
        
        return fetchedResultController
        
    }()
    
    var todoController: ToDoController?
    var todos: Todo? {
        didSet {
            print("Todos found")
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTable()
        tableView.allowsSelection = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        guard let colorHex = todos?.color else {fatalError()}
        title = todos?.title
        updateNavBar(withHexCode: colorHex)
    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {

        updateNavBar(withHexCode: "C6C2FF")
    }

    //MARK: - NavBar Setup Methods
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist!")
        }

        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError()}
        navBar.barTintColor =  navBarColor
        navBar.tintColor = ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)]


    }
    
    
    func customizeTable() {
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return fetchedResultsController.sections?.count ?? 1

    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath) as! TasksTableViewCell

    
        guard let todos = todos else {return cell}
    
           let tasks = fetchedResultsController.object(at: indexPath)
   
            cell.task = tasks
            cell.todoController = todoController
          
          
            
            if let color = UIColor(hexString: todos.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((todos.task?.count)!)) {
               
                cell.backgroundColor = color
                cell.tasksTitleLabel.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)

        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            //do stuff
            let tasks = self.fetchedResultsController.object(at: indexPath)
    
            self.todoController?.delete(task: tasks)
            completionHandler(true)
        })
        action.image = UIImage(named: "delete-icon")
        action.title = "Delete"
        action.backgroundColor = .red
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {return nil}
        
        return sectionInfo.name.capitalized
        
    }

    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddVC" {
            let detailVC = segue.destination as? AddTasksViewController
//            destinationVC?.toDoController = todoController
//            destinationVC?.todo = todos
            let ppc = detailVC?.popoverPresentationController
            if let button = sender as? UIButton {
                ppc?.sourceView = button
                ppc?.sourceRect = button.bounds
                ppc?.backgroundColor = .black
            }
            detailVC?.toDoController = todoController
            detailVC?.todo = todos
            ppc?.delegate = self
        }
       
    }
    
    @IBAction func unwindToTasksTableViewController(_ sender: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
   

}

extension TasksTableViewController: NSFetchedResultsControllerDelegate {
    
    //MARK: - NSFetchResultControllerDelegate
    
    //Tell the table view that were going to update
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    //tell the table were done updating
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //a single task
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            //            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            //            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    //section related updates
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
}
