//
//  ReminderController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData

class ReminderController {
    
    static let sharedController = ReminderController()
    
    var reminders: [Reminder] {
        let request = NSFetchRequest(entityName: "Reminder")
        
        do {
            var reminders = try Stack.sharedStack.managedObjectContext.executeFetchRequest(request) as! [Reminder]
            reminders.sortInPlace({$0.creationDate?.timeIntervalSince1970 > $1.creationDate?.timeIntervalSince1970})
            return reminders
        } catch {
            return []
        }
    }
    
    var completeReminders: [Reminder] {
        return reminders.filter({$0.isComplete!.boolValue})
    }
    
    var incompleteReminders: [Reminder] {
        return reminders.filter({!$0.isComplete!.boolValue})
    }
    
    var incompleteRemindersWithLocationUponLeaving: [Reminder] {
        return incompleteReminders.filter({$0.alertLabelText == "Upon Moving"})
    }
    
    var incompleteRemindersWithLocationUponArriving: [Reminder] {
        return incompleteReminders.filter({$0.alertLabelText == "Upon Arriving"})
    }
    
    
    func addReminder(reminder: Reminder) {
        saveToPersistentStorage()
    }
    
    func removeReminder(reminder: Reminder) {
        reminder.managedObjectContext?.deleteObject(reminder)
        if reminder.location != nil {
        LocationController.sharedController.remindersUsingLocationCount -= 1
        }
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved.")
        }
    }
    
//    func filePath(key: String) -> String {
//        let directorySearchResults = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
//        let documentsPath: AnyObject = directorySearchResults[0]
//        let entriesPath = documentsPath.stringByAppendingString("/\(key).plist")
//        
//        return entriesPath
//    }
    
    
}