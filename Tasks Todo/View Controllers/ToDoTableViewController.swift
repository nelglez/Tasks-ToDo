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

class ToDoTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    
    let todoController = ToDoController()

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeTable()
      
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded(_:)), name: .todoWasAdded, object: nil)
          
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
   

  
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//            let todo = todoController.todoList[indexPath.row]
//            
//            todoController.delete(todo: todo)
//            
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
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
   
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPopover" {
            let destinationVC = segue.destination as? AddTodoViewController
            destinationVC?.todoController = todoController
        } else if segue.identifier == "toToDoVC" {
            let destinationVC = segue.destination as? TasksTableViewController
            destinationVC?.todoController = todoController
            guard let index = tableView.indexPathForSelectedRow else {return}
            let todos = todoController.todoList[index.row]
            destinationVC?.todos = todos
        }
    }
    
    @IBAction func unwindToTodoTableViewController(_ sender: UIStoryboardSegue) {
    }
    

}
