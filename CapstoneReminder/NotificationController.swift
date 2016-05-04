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
        }
    }
    
    func notificationForReminder(reminder: Reminder) {
        let notification = UILocalNotification()
        notification.alertTitle = reminder.title
        notification.alertBody = reminder.title
        notification.fireDate = NSDate()
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        NSNotificationCenter.defaultCenter().postNotificationName("alert", object: nil)
    }
    
    
}