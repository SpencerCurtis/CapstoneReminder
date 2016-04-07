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
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    //    var locations: [CLLocation] = []
    let authState = CLLocationManager.authorizationStatus()
    
    var remindersUsingLocationCount: Int = 0 {
        didSet {
            if remindersUsingLocationCount == 0 {
                locationManager.stopUpdatingLocation()
                locationManager.stopMonitoringSignificantLocationChanges()
            }
            if ReminderController.sharedController.incompleteReminders.count == 0 {
                remindersUsingLocationCount = 0
            } else if ReminderController.sharedController.incompleteReminders.count > 0 {
                locationManager.startUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
                checkForRemindersOutsideOfRadius()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        checkForRemindersOutsideOfRadius()
        NSNotificationCenter.defaultCenter().postNotificationName("hasLocation", object: nil)
    }
    
    
    func sendNotificationForReminder(reminder: Reminder) {
        dispatch_async(dispatch_get_main_queue()) {
            let notification = UILocalNotification()
            notification.alertBody = reminder.title
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            
        }
        
    }
    
    func displayAlert(viewController: UIViewController, reminder: Reminder) {
        let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(okayAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func checkForRemindersOutsideOfRadius() {
        for reminder in ReminderController.sharedController.reminders {
            let status = CLLocationManager.authorizationStatus()
            if status == .AuthorizedWhenInUse {
                LocationController.sharedController.locationManager.startUpdatingLocation()
                LocationController.sharedController.locationManager.startMonitoringSignificantLocationChanges()
            }
            if reminder.locationLatitude != nil && reminder.locationLongitude != nil, let currentLocation = self.currentLocation {
                if currentLocation.distanceFromLocation(reminder.location!) > 15 && reminder.hasBeenNotified == false {
                    if UIApplication.sharedApplication().applicationState == .Active {
                        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
                        let alert = UIAlertController(title: "Check your reminders", message: "", preferredStyle: .Alert)
                        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
                            alert.dismissViewControllerAnimated(true, completion: nil)
                        })
                        alert.addAction(okayAction)
                        if let vc = vc {
                            vc.presentViewController(alert, animated: true, completion: nil)
                        }
                    } else {
                            let notification = UILocalNotification()
                            notification.alertTitle = reminder.title
                            notification.alertBody = reminder.title
                            notification.fireDate = NSDate()
                            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                            //                    sendNotificationForReminder(reminder)
                            NSNotificationCenter.defaultCenter().postNotificationName("alert", object: nil)
                        }
                    reminder.hasBeenNotified = true
                    locationManager.requestLocation()
                }
            }
        }
    }
    
    func requestLocations() {
        locationManager.delegate = self
        //        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func requestAuthorization() {
        
        if authState == CLAuthorizationStatus.NotDetermined || authState == CLAuthorizationStatus.Restricted {
            locationManager.requestWhenInUseAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //        requestAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed when getting users location")
    }
}



