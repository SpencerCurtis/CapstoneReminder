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
    
    convenience init(title: String, notes: String, alertLabelText: String, isComplete: Bool = false, creationDate: NSDate = NSDate(), latitude: CLLocationDegrees, longitude: CLLocationDegrees, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.notes = notes
        self.isComplete = isComplete
        self.alertLabelText = alertLabelText
        self.creationDate = creationDate
        self.locationLatitude = latitude
        self.locationLongitude = longitude
    }
    
    convenience init(title: String, notes: String, reminderTime: NSDate, alertLabelText: String, isComplete: Bool = false, creationDate: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.notes = notes
        self.reminderTime = reminderTime
        self.alertLabelText = alertLabelText
        self.isComplete = isComplete
        self.creationDate = creationDate
    }
    var location: CLLocation? {
        if let latitude = locationLatitude?.doubleValue, longitude = locationLongitude?.doubleValue {
            return CLLocation(latitude: latitude, longitude: longitude)
        } else {
            return nil
        }
    }
    
    
    private let kAlertLabelText = "alertLabelText"
    private let kCreationDate = "creationDate"
    private let kHasBeenNotified = "hasBeenNotified"
    private let kIsComplete = "isComplete"
    private let kLocationLatitude = "locationLatitude"
    private let kLocationLongitude = "locationLongitude"
    private let kNotes = "notes"
    private let kReminderTime = "reminderTime"
    private let kTitle = "title"
    private let kAtALocationLabelText = "atALocationLabelText"
    
    
    
}

extension Reminder {
    
    var dictionaryRepresentation: [String: AnyObject] {
        
        guard let alertLabelText = alertLabelText,
            creationDate = creationDate,
            hasBeenNotified = hasBeenNotified,
            isComplete = isComplete,
            locationLatitude = locationLatitude,
            locationLongitude = locationLongitude,
            notes = notes,
            title = title
            else { return [:] }
        
        return [kAlertLabelText: alertLabelText, kCreationDate: creationDate, kHasBeenNotified: hasBeenNotified, kIsComplete: isComplete, kLocationLatitude: locationLatitude, kLocationLongitude: locationLongitude, kNotes: notes, kReminderTime: reminderTime ?? NSDate(), kTitle: title, kAtALocationLabelText: atALocationLabelText ?? ""]
        
    }
    
    convenience init?(dictionary: [String: AnyObject], context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        
        guard let entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext:  context) else { return nil }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        guard let alertLabelText = dictionary[kAlertLabelText] as? String, creationDate = dictionary[kCreationDate] as? NSDate, hasBeenNotified = dictionary[kHasBeenNotified] as? NSNumber, locationLatitude = dictionary[kLocationLatitude] as? NSNumber, locationLongitude = dictionary[kLocationLongitude] as? NSNumber, notes = dictionary[kNotes] as? String else { return nil }
        
        self.alertLabelText = alertLabelText
        self.creationDate = creationDate
        self.hasBeenNotified = hasBeenNotified
        self.isComplete = false
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        self.notes = notes
    }
}
