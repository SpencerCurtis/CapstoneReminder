//
//  LocationController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/25/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import AudioToolbox

class LocationController: NSObject, CLLocationManagerDelegate {
    static let sharedController = LocationController()
    
    var currentLocation: CLLocation?
    
    var selectedLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    var reminder: Reminder?
    
    var atALocationTextName: String?
    var atALocationTextAddress: String?
    
    let authState = CLLocationManager.authorizationStatus()
    
    
    override init() {
        super.init()
        reminder = nil
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    var remindersUsingLocationCount = 0
    
    func increaseLocationCount() {
        remindersUsingLocationCount += 1
    }
    
    func decreaseLocationCount() {
        remindersUsingLocationCount -= 1
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        NotificationCenter.default.post(name: Notification.Name(rawValue: "hasLocation"), object: nil)
    }
    
    func displayAlert(_ viewController: UIViewController, reminder: Reminder) {
        let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okayAction)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        var reminderForRegion: Reminder? = nil
        for reminder in ReminderController.sharedController.reminders {
            if reminder.title == region.identifier {
                reminderForRegion = reminder
            }
        }
        if let reminder = reminderForRegion {
            if UIApplication.shared.applicationState == .active {
                NotificationController.sharedController.alertForReminder(reminder)
                print("Geofence triggered")
            } else {
                NotificationController.sharedController.notificationForReminder(reminder)
                print("Geofence triggered")
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        var reminderForRegion: Reminder? = nil
        for reminder in ReminderController.sharedController.reminders {
            if reminder.title == region.identifier {
                reminderForRegion = reminder
            }
        }
        if let reminder = reminderForRegion {
            if UIApplication.shared.applicationState == .active {
                NotificationController.sharedController.alertForReminder(reminder)
                print("Geofence triggered")
            } else {
                NotificationController.sharedController.notificationForReminder(reminder)
                print("Geofence triggered")
            }
        }
    }
    
    
    
    func requestLocations() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func requestAuthorization() {
        
        if authState == CLAuthorizationStatus.notDetermined || authState == CLAuthorizationStatus.restricted {
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
            locationManager.requestLocation()
        } else {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed when getting users location")
    }
}



