//
//  AddTodoViewController.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {
    @IBOutlet weak var todoTitleLabel: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var todoController: ToDoController?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        guard let title = todoTitleLabel.text, !title.isEmpty else {return}
        
        todoController?.create(todosWith: title)
        
        NotificationCenter.default.post(name: .todoWasAdded, object: self)
        
      //  navigationController?.popViewController(animated: true)
        
    }
    

}
