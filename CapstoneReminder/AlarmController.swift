//
//  AlarmController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 4/1/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class AlarmController  {
    
    static let sharedController = AlarmController()
    
    
    
    func sendNotificationForReminderWithTime(reminder: Reminder, fireDate: NSDate) {
        if reminder.hasBeenNotified == false {
            let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
            let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .Alert)
            let okayAction = UIAlertAction(title: "Dismiss", style: .Default, handler: { (action) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okayAction)
            let notification = UILocalNotification()
            notification.fireDate = fireDate
            notification.alertBody = reminder.title
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            if let vc = vc {
                if NSDate().timeIntervalSince1970 > fireDate.timeIntervalSince1970 {
                    vc.presentViewController(alert, animated: true, completion: nil)
                    let notification = UILocalNotification()
                    notification.fireDate = fireDate
                    notification.alertBody = reminder.title
                    notification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    reminder.hasBeenNotified = true
                    ReminderController.sharedController.saveToPersistentStorage()
                    
                    
                }
            }
        }
    }
}
