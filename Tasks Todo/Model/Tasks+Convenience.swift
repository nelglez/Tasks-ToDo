//
//  Tasks+Convenience.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreData

enum Priority: String, CaseIterable {
    case low
    case normal
    case high
    case critical
    
    static var allPriorities: [Priority] {
        return [.low, .normal, .high, .critical]
    }
}

extension Task {
    @discardableResult convenience init(title: String, priority: Priority = .normal, creationDate: Date = Date(), isDone: Bool = false, todo: Todo, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.priority = priority.rawValue
        self.creationDate = creationDate
        self.isDone = isDone
        self.todo = todo
    
    }
}
