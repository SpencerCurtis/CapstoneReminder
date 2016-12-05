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
    
    convenience init(title: String, notes: String, alertLabelText: String, isComplete: Bool = false, creationDate: Date = Date(), latitude: CLLocationDegrees, longitude: CLLocationDegrees, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        self.title = title
        self.notes = notes
        self.isComplete = isComplete as NSNumber?
        self.alertLabelText = alertLabelText
        self.creationDate = creationDate
        self.locationLatitude = latitude as NSNumber?
        self.locationLongitude = longitude as NSNumber?
    }
    
    convenience init(title: String, notes: String, reminderTime: Date, alertLabelText: String, isComplete: Bool = false, creationDate: Date = Date(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        self.title = title
        self.notes = notes
        self.reminderTime = reminderTime
        self.alertLabelText = alertLabelText
        self.isComplete = isComplete as NSNumber?
        self.creationDate = creationDate
    }
    var location: CLLocation? {
        if let latitude = locationLatitude?.doubleValue, let longitude = locationLongitude?.doubleValue {
            return CLLocation(latitude: latitude, longitude: longitude)
        } else {
            return nil
        }
    }
    
    
    fileprivate let kAlertLabelText = "alertLabelText"
    fileprivate let kCreationDate = "creationDate"
    fileprivate let kHasBeenNotified = "hasBeenNotified"
    fileprivate let kIsComplete = "isComplete"
    fileprivate let kLocationLatitude = "locationLatitude"
    fileprivate let kLocationLongitude = "locationLongitude"
    fileprivate let kNotes = "notes"
    fileprivate let kReminderTime = "reminderTime"
    fileprivate let kTitle = "title"
    fileprivate let kAtALocationLabelText = "atALocationLabelText"
    
    
    
}

extension Reminder {
    
    var dictionaryRepresentation: [String: Any] {
        
        guard let alertLabelText = alertLabelText,
            let creationDate = creationDate,
            let hasBeenNotified = hasBeenNotified,
            let isComplete = isComplete,
            let locationLatitude = locationLatitude,
            let locationLongitude = locationLongitude,
            let notes = notes,
            let title = title
            else { return [:] }
        
        return [kAlertLabelText: alertLabelText, kCreationDate: creationDate, kHasBeenNotified: hasBeenNotified, kIsComplete: isComplete, kLocationLatitude: locationLatitude, kLocationLongitude: locationLongitude, kNotes: notes, kReminderTime: reminderTime ?? Date(), kTitle: title, kAtALocationLabelText: atALocationLabelText as AnyObject? ?? ""]
        
    }
    
    convenience init?(dictionary: [String: AnyObject], context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Reminder", in:  context) else { return nil }
        
        self.init(entity: entity, insertInto: context)
        
        guard let alertLabelText = dictionary[kAlertLabelText] as? String, let creationDate = dictionary[kCreationDate] as? Date, let hasBeenNotified = dictionary[kHasBeenNotified] as? NSNumber, let locationLatitude = dictionary[kLocationLatitude] as? NSNumber, let isComplete = dictionary[kIsComplete] as? NSNumber, let locationLongitude = dictionary[kLocationLongitude] as? NSNumber, let notes = dictionary[kNotes] as? String else { return nil }
        
        self.alertLabelText = alertLabelText
        self.creationDate = creationDate
        self.hasBeenNotified = hasBeenNotified
        self.isComplete = isComplete
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        self.notes = notes
    }
}
