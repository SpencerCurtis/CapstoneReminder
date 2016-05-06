//
//  NotificationController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 5/4/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class NotificationController {
    
    static let sharedController = NotificationController()
    
    func alertForReminder(reminder: Reminder) {
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Dismiss", style: .Default, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(okayAction)
        if let vc = vc {
            vc.presentViewController(alert, animated: true, completion: nil)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    func notificationForReminder(reminder: Reminder) {
        let notification = UILocalNotification()
        notification.alertBody = reminder.title
        notification.fireDate = NSDate()
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        NSNotificationCenter.defaultCenter().postNotificationName("alert", object: nil)
    }
    
//    func notificationButtonAction(reminder: Reminder) {
//        let completedButtonAction = UIMutableUserNotificationAction()
//        completedButtonAction.title = "Mark as completed"
//        completedButtonAction.activationMode = UIUserNotificationActivationMode.Background
//        completedButtonAction.authenticationRequired = true
//        completedButtonAction.destructive = false
//        completedButtonAction.identifier = "Completed"
//        
//        let completedCategory = UIMutableUserNotificationCategory()
//        completedCategory.identifier = "COMPLETED_CATEGORY"
//        completedCategory.setActions([completedButtonAction], forContext: UIUserNotificationActionContext.Default)
//        
//        
//        
//    }
//    
//    func markAsCompleted(reminder: Reminder) {
//        reminder.isComplete = true
//        ReminderController.sharedController.saveToPersistentStorage()
//    }
//    
}

// TODO: make a "Mark as Complete" button on the alerts and notifications.