//
//  Reminder.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/24/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData


class Reminder: NSManagedObject {
    
    convenience init(title: String, notes: String, isComplete: Bool = false, reminderTime: NSDate, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.notes = notes
        self.isComplete = false
        self.reminderTime = NSDate()
        self.alertLabelText = ""
        
    }
}