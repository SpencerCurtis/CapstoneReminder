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
    
    func regionWithReminderUponArriving(reminder: Reminder) -> CLCircularRegion? {
        if LocationController.sharedController.locationManager.monitoredRegions.count <= 20 {
            let region = CLCircularRegion(center: reminder.location!.coordinate, radius: 300, identifier: reminder.title!)
            
            region.notifyOnEntry = true
            region.notifyOnExit = false
            return region
        } else {
            simpleAlert("Error", message: "You can only have 20 remindrs that use location at a time. Please delete or check ones you don't need anymore, then try again.")
            return nil
        }
        
        
    }
    
    func regionWithReminderUponMoving(reminder: Reminder) -> CLCircularRegion? {
        if LocationController.sharedController.locationManager.monitoredRegions.count <= 20 {
            let region = CLCircularRegion(center: reminder.location!.coordinate, radius: 300, identifier: reminder.title!)
            region.notifyOnEntry = false
            region.notifyOnExit = true
            return region
        } else {
            simpleAlert("Error", message: "You can only have 20 remindrs that use location at a time. Please delete or check ones you don't need anymore, then try again.")
            return nil
        }
        
    }
    
    func startMonitoringReminderUponMoving(reminder: Reminder) {
        guard CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) == true else {
            simpleAlert("Error", message: "Geofencing is not supported on this device")
            return
        }
        if let region = regionWithReminderUponMoving(reminder) {
            LocationController.sharedController.locationManager.startMonitoringForRegion(region)
        }
    }
    
    
    
    func startMonitoringReminderUponArriving(reminder: Reminder) {
        guard CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) == true else {
            simpleAlert("Error", message: "Geofencing is not supported on this device")
            return
        }
        if let region = regionWithReminderUponArriving(reminder) {
            LocationController.sharedController.locationManager.startMonitoringForRegion(region)
        }
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