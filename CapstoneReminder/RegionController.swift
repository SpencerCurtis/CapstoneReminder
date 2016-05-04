//
//  RegionController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 5/4/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class RegionController {
    
    static let sharedController = RegionController()
    
    func regionWithReminder(reminder: Reminder) -> CLCircularRegion {
        
        let region = CLCircularRegion(center: reminder.location!.coordinate, radius: 400, identifier: reminder.title!)
        
        region.notifyOnEntry = true
        region.notifyOnExit = false
        return region
        
    }
    
    
    func startMonitoringReminder(reminder: Reminder) {
        guard CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) == true else {
            simpleAlert("Error", message: "Geofencing is not supported on this device")
            return
        }
        let region = regionWithReminder(reminder)
        LocationController.sharedController.locationManager.startMonitoringForRegion(region)
    }
    
    func stopMonitoringReminder(reminder: Reminder) {
        for region in LocationController.sharedController.locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == reminder.title {
                    LocationController.sharedController.locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }
}


func simpleAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
    alert.addAction(dismissAction)
    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
}