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
    var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    var remindersUsingLocationCount: Int = 0 {
        didSet {
            if remindersUsingLocationCount == 0 {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.last
        }
        if let currentLocation = currentLocation {
            if locations.last?.distanceFromLocation(currentLocation) > 10 {
                let notification = UILocalNotification()
                notification.alertBody = "Check your reminders!"
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                remindersUsingLocationCount -= 1
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
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