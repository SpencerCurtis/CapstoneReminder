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
        dispatch_async(dispatch_get_main_queue()) {
            if UIApplication.sharedApplication().applicationState == .Active && reminder.hasBeenNotified == false {
                let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
                let alert = UIAlertController(title: "Check your reminders", message: "", preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(okayAction)
                if let vc = vc {
                    vc.presentViewController(alert, animated: true, completion: nil)
                    reminder.hasBeenNotified = true
                }
            } else if UIApplication.sharedApplication().applicationState == .Background && reminder.hasBeenNotified == false {
                let notification = UILocalNotification()
                notification.fireDate = fireDate
                notification.alertBody = reminder.title
                notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                reminder.hasBeenNotified = true
            }
        }
    }
}