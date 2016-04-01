//
//  AlarmController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 4/1/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit

class AlarmController  {
    
    static let sharedController = AlarmController()
    
    let notification = UILocalNotification()
    
    func sendNotificationForReminderWithTime(reminder: Reminder, fireDate: NSDate) {
        notification.fireDate = fireDate
        notification.alertBody = reminder.title
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
