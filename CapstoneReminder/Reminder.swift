//
//  Reminder.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/28/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


class Reminder: NSManagedObject {
    
    convenience init(title: String, notes: String, reminderTime: NSDate, isComplete: Bool = false, creationDate: NSDate = NSDate(), latitude: CLLocationDegrees, longitude: CLLocationDegrees, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.notes = notes
        self.isComplete = isComplete
        self.reminderTime = reminderTime
        self.creationDate = creationDate
        self.locationLatitude = latitude
        self.locationLongitude = longitude
    }
    
    var location: CLLocation? {
        if let latitude = locationLatitude?.doubleValue, longitude = locationLongitude?.doubleValue {
            return CLLocation(latitude: latitude, longitude: longitude)
        } else {
            return nil
        }
    }
}
