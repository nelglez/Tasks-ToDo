//
//  AddTodoViewController.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var todoTitleLabel: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var todoController: ToDoController?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        todoTitleLabel.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        guard let title = todoTitleLabel.text, !title.isEmpty else {return}
        
        todoController?.create(todosWith: title)
        
        NotificationCenter.default.post(name: .todoWasAdded, object: self)
        
        todoTitleLabel.resignFirstResponder()
    }
    

}
