//
//  Reminder.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/25/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData


class Reminder: NSManagedObject {
    
    convenience init(title: String, notes: String, reminderTime: NSDate, isComplete: Bool = false, creationDate: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.notes = notes
        self.isComplete = isComplete
        self.reminderTime = reminderTime
        self.creationDate = creationDate
    }
}