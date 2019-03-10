//
//  ToDo+Convenience.swift
//  Tasks Todo
//
//  Created by Nelson Gonzalez on 3/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreData
import ChameleonFramework

extension Todo {
    @discardableResult convenience init(title: String, creationDate: Date = Date(), color: String = UIColor.randomFlat().hexValue(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.creationDate = creationDate
        self.color = color
    }
}
