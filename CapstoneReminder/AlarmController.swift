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
    
    
    
    func sendNotificationForReminderWithTime(_ reminder: Reminder, fireDate: Date) {
        if reminder.hasBeenNotified == false {
            let vc = UIApplication.shared.keyWindow?.rootViewController
            let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okayAction)
            let notification = UILocalNotification()
            notification.fireDate = fireDate
            notification.alertBody = reminder.title
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
            if let vc = vc {
                if Date().timeIntervalSince1970 > fireDate.timeIntervalSince1970 {
                    vc.present(alert, animated: true, completion: nil)
                    let notification = UILocalNotification()
                    notification.fireDate = fireDate
                    notification.alertBody = reminder.title
                    notification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.shared.scheduleLocalNotification(notification)
                    reminder.hasBeenNotified = true
                    ReminderController.sharedController.saveToPersistentStorage()
                    
                    
                }
            }
        }
    }
}
