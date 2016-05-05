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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        NSNotificationCenter.defaultCenter().postNotificationName("hasLocation", object: nil)
    }
    
    func displayAlert(viewController: UIViewController, reminder: Reminder) {
        let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(okayAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        var reminderForRegion: Reminder? = nil
        for reminder in ReminderController.sharedController.reminders {
            if reminder.title == region.identifier {
                reminderForRegion = reminder
            }
        }
        if let reminder = reminderForRegion {
            if UIApplication.sharedApplication().applicationState == .Active {
                NotificationController.sharedController.alertForReminder(reminder)
                print("geofence triggered")
            } else {
                NotificationController.sharedController.notificationForReminder(reminder)
                print("geofence triggered")
            }
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        var reminderForRegion: Reminder? = nil
        for reminder in ReminderController.sharedController.reminders {
            if reminder.title == region.identifier {
                reminderForRegion = reminder
            }
        }
        if let reminder = reminderForRegion {
            if UIApplication.sharedApplication().applicationState == .Active {
                NotificationController.sharedController.alertForReminder(reminder)
                print("geofence triggered")
            } else {
                NotificationController.sharedController.notificationForReminder(reminder)
                print("geofence triggered")
            }
        }
    }
    
    
    
    func requestLocations() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func requestAuthorization() {
        
        if authState == CLAuthorizationStatus.NotDetermined || authState == CLAuthorizationStatus.Restricted {
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
            locationManager.requestLocation()
        } else {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        locationManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed when getting users location")
    }
}



