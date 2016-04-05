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
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
<<<<<<< 4b6985deb006e249cdf63522c857e2545b654078

=======
>>>>>>> Implemented Alerts to be notified if the user is still in the app upon leaving radius. I'm not sure if I need to use startUpdatingLocation() or startMonitoringSignificantLocationChanges.
    }
    
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
        NSNotificationCenter.defaultCenter().postNotificationName("hasLocation", object: nil)
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
                    ReminderDetailViewController.sharedController.displayAlertForReminder(reminder)
                    reminder.hasBeenNotified = true
<<<<<<< 4b6985deb006e249cdf63522c857e2545b654078
                    locationManager.stopUpdatingLocation()
=======
                    locationManager.stopMonitoringSignificantLocationChanges()
>>>>>>> Implemented Alerts to be notified if the user is still in the app upon leaving radius. I'm not sure if I need to use startUpdatingLocation() or startMonitoringSignificantLocationChanges.
                }
            }
        }
    }
    
<<<<<<< 4b6985deb006e249cdf63522c857e2545b654078
    func checkForLocation() {
        if currentLocation == nil {
            
        } else if currentLocation != nil {
            
        }
=======
    func requestLocation() {
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
>>>>>>> Implemented Alerts to be notified if the user is still in the app upon leaving radius. I'm not sure if I need to use startUpdatingLocation() or startMonitoringSignificantLocationChanges.
    }
    
    func requestAuthorization() {
        
        if authState == CLAuthorizationStatus.NotDetermined {
            locationManager.delegate = self
<<<<<<< 4b6985deb006e249cdf63522c857e2545b654078
            locationManager.requestAlwaysAuthorization()
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
=======
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            locationManager.startMonitoringSignificantLocationChanges()
>>>>>>> Implemented Alerts to be notified if the user is still in the app upon leaving radius. I'm not sure if I need to use startUpdatingLocation() or startMonitoringSignificantLocationChanges.
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        requestAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed when getting users location")
    }
}



