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
    
    func alertForReminder(_ reminder: Reminder) {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okayAction)
        if let vc = vc {
            vc.present(alert, animated: true, completion: nil)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    func notificationForReminder(_ reminder: Reminder) {
        let notification = UILocalNotification()
        notification.alertBody = reminder.title
        notification.fireDate = Date()
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.presentLocalNotificationNow(notification)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "alert"), object: nil)
    }
    
}

// TODO: make a "Mark as Complete" button on the alerts and notifications.
