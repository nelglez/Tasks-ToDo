//
//  TasksTableViewController.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import ChameleonFramework
import SwipeCellKit

class TasksTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
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

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos?.task?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath) as! TasksTableViewCell

        if let todos = todos, let tasks = todos.task?.object(at: indexPath.row) as? Task {
            
            cell.task = tasks
            cell.todoController = todoController
            cell.delegate = self
          
            
            if let color = UIColor(hexString: todos.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((todos.task?.count)!)) {
               
                cell.backgroundColor = color
                cell.tasksTitleLabel.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
              
            }
            
          //   cell.accessoryType = tasks.isDone ? .checkmark : .none

        }

        return cell
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        guard let todos = todos, let tasks = todos.task?.object(at: indexPath.row) as? Task else {return}
//
//        if tasks.isDone == false {
//            tasks.isDone = true
//            todoController?.updateTasksDone(task: tasks, done: true)
//
//        } else {
//            tasks.isDone = false
//            todoController?.updateTasksDone(task: tasks, done: false)
//
//        }
//
//        tableView.reloadData()
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            print("Delete cell")
            
           // let todo = self.todoController?.todoList[indexPath.row]
            guard let  todos = self.todos, let tasks = todos.task?.object(at: indexPath.row) as? Task else {return}
            
            
            self.todoController?.delete(task: tasks)
            
            
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddVC" {
            let destinationVC = segue.destination as? AddTasksViewController
            destinationVC?.toDoController = todoController
            destinationVC?.todo = todos
        }
       
    }
   

}
