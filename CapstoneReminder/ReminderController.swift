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
    
//    var mockReminders: [Reminder]  {
    
        
//        let r1 = Reminder(title: "Pay Rent", notes: "Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes Mock Notes ", isComplete: false)
//        let r2 = Reminder(title: "Grab Lunch", notes: "Spencer: Turkey Club, Ryan: Barbeque Sandwich", isComplete: false)
//        let r3 = Reminder(title: "Renew Spotify Subscription", notes: "Renew subscription before it expires on 4/12/16", isComplete: false)
//        
//        return [r1, r2, r3]
//    }
    
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
    
    func addReminder(reminder: Reminder) {
        saveToPersistentStorage()
    }
    
    func removeReminder(reminder: Reminder) {
        reminder.managedObjectContext?.deleteObject(reminder)
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
    
    func filePath(key: String) -> String {
        let directorySearchResults = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
        let documentsPath: AnyObject = directorySearchResults[0]
        let entriesPath = documentsPath.stringByAppendingString("/\(key).plist")
        
        return entriesPath
    }
    
    
}