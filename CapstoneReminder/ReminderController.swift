//
//  ReminderController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
        if reminder.alertLabelText != "Upon Arriving" && reminder.alertLabelText != "Upon Moving" {
            saveToPersistentStorage()
        } else if reminder.alertLabelText == "Upon Arriving" && LocationController.sharedController.locationManager.monitoredRegions.count <= 20 {
            RegionController.sharedController.startMonitoringReminderUponArriving(reminder)
            reminder.atALocationLabelText = LocationController.sharedController.atALocationTextName
            saveToPersistentStorage()
        } else if reminder.alertLabelText == "Upon Moving" && LocationController.sharedController.locationManager.monitoredRegions.count <= 20 {
            RegionController.sharedController.startMonitoringReminderUponMoving(reminder)
            saveToPersistentStorage()
        } else if LocationController.sharedController.locationManager.monitoredRegions.count > 20 {
            simpleAlert("Error", message: "You can only have 20 remindrs that use location at a time. Please delete or check ones you don't need anymore, then try again.")
        }
    }
    
    func removeReminder(reminder: Reminder) {
        
        reminder.managedObjectContext?.deleteObject(reminder)
        if reminder.location != nil {
            LocationController.sharedController.decreaseLocationCount()
        }
        if reminder.alertLabelText == "Upon Arriving" {
            RegionController.sharedController.stopMonitoringReminder(reminder)
        }
        saveToPersistentStorage()
        
        
        deleteNotificationForRemindr(reminder)
    }
    
    func deleteNotificationForRemindr(reminder: Reminder) {
        guard let scheduledNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
        
        for notification in scheduledNotifications {
            if notification.alertBody == reminder.title {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved.")
        }
    }
}