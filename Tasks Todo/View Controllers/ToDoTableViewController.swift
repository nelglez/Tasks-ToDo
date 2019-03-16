//
//  ToDoTableViewController.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class ToDoTableViewController: UITableViewController, SwipeTableViewCellDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var popOverView: UIView!
    
    
    let todoController = ToDoController()

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeTable()
      
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded(_:)), name: .todoWasAdded, object: nil)
        
        
    }
    
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist!")
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError()}
        navBar.barTintColor =  navBarColor
        navBar.tintColor = ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       updateNavBar(withHexCode: "C6C2FF")
    }
    
    @objc func newTodoAdded(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
 
    
    func customizeTable() {
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return todoController.todoList.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! SwipeTableViewCell

        let todos = todoController.todoList[indexPath.row]
        cell.textLabel?.text = todos.title
        cell.delegate = self
        guard let categoryColor = UIColor(hexString: todos.color ) else {fatalError()}
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: categoryColor, returnFlat: true)

        return cell
    }
   
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            print("Delete cell")
            
            let todo = self.todoController.todoList[indexPath.row]
            
            self.todoController.delete(todo: todo)
            
            
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
   
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPopover" {
            let detailVC = segue.destination as? AddTodoViewController
            let ppc = detailVC?.popoverPresentationController
            if let button = sender as? UIButton {
                ppc?.sourceView = button
                ppc?.sourceRect = button.bounds
                ppc?.backgroundColor = .black
            }
            detailVC?.todoController = todoController
            ppc?.delegate = self
        } else if segue.identifier == "toToDoVC" {
            let destinationVC = segue.destination as? TasksTableViewController
            destinationVC?.todoController = todoController
            guard let index = tableView.indexPathForSelectedRow else {return}
            let todos = todoController.todoList[index.row]
            destinationVC?.todos = todos
        } 
    }
    
    @IBAction func unwindToTodoTableViewController(_ sender: UIStoryboardSegue) {
    tableView.reloadData()
    }
    
    
    @IBAction func shareAppBarButtonPressed(_ sender: UIBarButtonItem) {
        //https://stackoverflow.com/questions/37938722/how-to-implement-share-button-in-swift
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
     
        let image = #imageLiteral(resourceName: "todo-list copy")
        
        let textToShare = "Check out this app"
        
        if let myWebsite = URL(string: "http://itunes.apple.com/us/app/task-todo-lists/id1456267861") {
            let objectsToShare = [textToShare, myWebsite, image] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
           
            self.present(activityVC, animated: true, completion: nil)
            //https://medium.com/@dushyant_db/how-to-present-uiactivityviewcontroller-on-iphone-and-ipad-ae72013d2a5a
            if let popOver = activityVC.popoverPresentationController {
                popOver.sourceView = self.view
                popOver.barButtonItem = sender
            }
        }
    }
    
    
    
}
