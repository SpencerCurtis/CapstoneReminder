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
    
    override init() {
        super.init()
        reminder = nil
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
    
    func displayAlert(viewController: UIViewController, reminder: Reminder) {
        let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(okayAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func checkForRemindersOutsideOfRadius() {
        for reminder in ReminderController.sharedController.incompleteRemindersWithLocationUponLeaving {
            let index = ReminderController.sharedController.reminders.indexOf(reminder)
            let status = CLLocationManager.authorizationStatus()
            if status == .AuthorizedWhenInUse {
                LocationController.sharedController.locationManager.startUpdatingLocation()
                LocationController.sharedController.locationManager.startMonitoringSignificantLocationChanges()
            }
            if reminder.alertLabelText == "Upon Moving", let currentLocation = self.currentLocation, location = reminder.location {
                if location.distanceFromLocation(currentLocation) > 15 && ReminderController.sharedController.reminders[index!].hasBeenNotified == false {
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
                        ReminderController.sharedController.reminders[index!].hasBeenNotified = true
                        ReminderController.sharedController.saveToPersistentStorage()
                    } else if UIApplication.sharedApplication().applicationState == .Background && reminder.hasBeenNotified == false {
                        let notification = UILocalNotification()
                        notification.alertTitle = reminder.title
                        notification.alertBody = reminder.title
                        notification.fireDate = NSDate()
                        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                        NSNotificationCenter.defaultCenter().postNotificationName("alert", object: nil)
                        ReminderController.sharedController.reminders[index!].hasBeenNotified = true
                        ReminderController.sharedController.saveToPersistentStorage()
                    }
                } else {
                    locationManager.requestLocation()
                }
            }
        }
    }
    
    func checkIfUserHasArrivedAtLocation() {
        for reminder in ReminderController.sharedController.incompleteRemindersWithLocationUponArriving {
            let index = ReminderController.sharedController.reminders.indexOf(reminder)
            let status = CLLocationManager.authorizationStatus()
            if status == .AuthorizedWhenInUse {
                LocationController.sharedController.locationManager.startUpdatingLocation()
                LocationController.sharedController.locationManager.startMonitoringSignificantLocationChanges()
            }
            if let currentLocation = self.currentLocation, location = reminder.location {
                if location.distanceFromLocation(currentLocation) < 15 && ReminderController.sharedController.reminders[index!].hasBeenNotified == false {
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
                        ReminderController.sharedController.reminders[index!].hasBeenNotified = true
                        ReminderController.sharedController.saveToPersistentStorage()
                    } else if UIApplication.sharedApplication().applicationState == .Background && reminder.hasBeenNotified == false {
                        let notification = UILocalNotification()
                        notification.alertTitle = reminder.title
                        notification.alertBody = reminder.title
                        notification.fireDate = NSDate()
                        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                        NSNotificationCenter.defaultCenter().postNotificationName("alert", object: nil)
                        ReminderController.sharedController.reminders[index!].hasBeenNotified = true
                        ReminderController.sharedController.saveToPersistentStorage()
                    }
                } else {
                    locationManager.requestLocation()
                    
                }
            }
        }
    }
    
    func requestLocations() {
        locationManager.delegate = self
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
        locationManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed when getting users location")
    }
}



