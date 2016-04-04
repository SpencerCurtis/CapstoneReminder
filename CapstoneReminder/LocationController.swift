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
    let authState = CLLocationManager.authorizationStatus()
    
    var remindersUsingLocationCount: Int = 0 {
        didSet {
            if remindersUsingLocationCount == 0 {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations = locations
        currentLocation = locations.last
        checkForRemindersOutsideOfRadius()
    }
    
    
    func sendNotificationForReminder(reminder: Reminder) {
        let notification = UILocalNotification()
        notification.alertBody = reminder.title
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    func checkForRemindersOutsideOfRadius() {
        for reminder in ReminderController.sharedController.reminders {
            if let currentLocation = currentLocation {
                // Check if hasBeenNotified == false
                if currentLocation.distanceFromLocation(reminder.location!) > 15 && reminder.hasBeenNotified == false {
                    sendNotificationForReminder(reminder)
                    reminder.hasBeenNotified = true
                    locationManager.stopUpdatingHeading()
                }
            }
        }
    }
    
    func requestLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        print("")
    }
    
    func requestAuthorization() {
        
        if authState == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        requestAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed when getting users location")
    }
}



