//
//  ToDoController.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreData

class ToDoController {
    
    
    var todoList: [Todo] {
        
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return (try? CoreDataStack.shared.mainContext.fetch(request)) ?? []
    }
    
    //MARK: - CRUD Todo
    
    func create(todosWith title: String) {
        let _ = Todo(title: title)
        saveToPersistentStore()
    }
    
    func updateTodoTitle(todo: Todo, title: String) {
        todo.title = title
        saveToPersistentStore()
    }
    
    func delete(todo: Todo) {
        if let moc = todo.managedObjectContext {
            moc.delete(todo)
            saveToPersistentStore()
        }
    }
    
    //MARK: - CRUD Tasks
    
    func create(taskWith title: String, priority: Priority, todo: Todo) {
        let _ = Task(title: title, priority: priority, todo: todo)
        saveToPersistentStore()
    }
    
    func delete(task: Task) {
        if let moc = task.managedObjectContext {
            moc.delete(task)
            saveToPersistentStore()
        }
    }
    
    
    
    func updateTasksDone(task: Task, done: Bool){
        task.isDone = done
        saveToPersistentStore()
    }
    
    func updateTaskTitle(task: Task, title: String) {
        task.title = title
        saveToPersistentStore()
    }

    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch let error {
            print("There was a problem saving to the persistent store: \(error)")
        }
    }
}
