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
            let notification = UILocalNotification()
            notification.fireDate = fireDate
            notification.alertBody = reminder.title
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
}
