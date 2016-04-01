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

class LocationController: NSObject, CLLocationManagerDelegate {
    static let sharedController = LocationController()
    
    var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    var locations: [CLLocation] = []
    
    var remindersUsingLocationCount: Int = 0 {
        didSet {
            if remindersUsingLocationCount == 0 {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        self.locations = locations
        if currentLocation == nil {
            currentLocation = locations.last
        }
        
        for reminder in ReminderController.sharedController.reminders {
            if let currentLocation = currentLocation {
                if currentLocation.distanceFromLocation(reminder.location!) > 15 {
                    sendNotification()
                } else {
                    break
                }
            }
        }
    }
    
    
    func sendNotification() {
        let notification = UILocalNotification()
        notification.alertBody = "Check your reminders!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        locationManager.stopUpdatingLocation()
        remindersUsingLocationCount -= 1
        
    }
    
    func requestLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        print("")
    }
    
    func requestAuthorization() {
        let authState = CLLocationManager.authorizationStatus()
        if authState == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        requestAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed when getting users location")
    }
    
    func localNotificationFired() {
        let alertController = UIAlertController(title: "Reminder!", message: "Check your reminders.", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        
        alertController.addAction(action)
        
        //        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}