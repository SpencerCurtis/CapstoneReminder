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
    
    var mockReminders: [Reminder]  {
        let r1 = Reminder(title: "Pay Rent", notes: "Mock Notes")
        let r2 = Reminder(title: "Grab Lunch", notes: "Spencer: Turkey Club, Ryan: Barbeque Sandwich")
        let r3 = Reminder(title: "Renew Spotify Subscription", notes: "Renew subscription before it expires on 4/12/16")
        
        return [r1, r2, r3]
    }
    
    var reminders: [Reminder] {
        let request = NSFetchRequest(entityName: "Reminder")
        
        do {
            return try Stack.sharedStack.managedObjectContext.executeFetchRequest(request) as! [Reminder]
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