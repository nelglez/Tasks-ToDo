//
//  AddTasksViewController.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class AddTasksViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var prioritySegementedControl: UISegmentedControl!
    @IBOutlet weak var tasksTitleTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var toDoController: ToDoController?
    
    var todo: Todo?
    let index: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        prioritySegementedControl.selectedSegmentIndex = index
        tasksTitleTextField.delegate = self
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        guard let title = tasksTitleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Error!", message: "Please enter a title", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)

            present(alert, animated: true, completion: nil)
            return
            
        }
        
        guard let todo = todo else {return}
        
        let segmentedControlIndex = prioritySegementedControl.selectedSegmentIndex
        
        let priority = Priority.allPriorities[segmentedControlIndex]
  
            toDoController?.create(taskWith: title, priority: priority, todo: todo)
   
            tasksTitleTextField.resignFirstResponder()
    }
    
}
