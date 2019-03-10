//
//  TasksTableViewCell.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import ChameleonFramework
import SwipeCellKit

class TasksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tasksTitleLabel: UILabel!

    @IBOutlet weak var doneButton: UIButton!
    
    var todoController: ToDoController?
   
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func updateViews() {
        guard let task = task else {return}
        tasksTitleLabel.text = task.title
        
        doneButton.layer.cornerRadius = 5
        
        if task.isDone == true {
            doneButton.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            doneButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        guard let task = task else {return}
        
        if task.isDone == false {
            task.isDone = true
            todoController?.updateTasksDone(task: task, done: true)
            updateViews()
        } else {
            task.isDone = false
            todoController?.updateTasksDone(task: task, done: false)
            updateViews()
        }
    }
    
}
