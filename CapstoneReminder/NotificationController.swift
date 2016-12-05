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
import UserNotifications

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
        guard let reminderTitle = reminder.title else { NSLog("No title found for reminder, cannot create a notification."); return }
        
        let identifier = "reminder"
        let content = UNMutableNotificationContent()
    
        content.body = reminderTitle
        
        content.sound = UNNotificationSound.default()
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            guard let error = error else { print("Successfully scheduled notification"); return }
            print(error.localizedDescription)
        }
    }
    
}

// TODO: make a "Mark as Complete" button on the alerts and notifications.
