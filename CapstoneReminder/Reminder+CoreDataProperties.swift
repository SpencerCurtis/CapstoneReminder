//
//  Reminder+CoreDataProperties.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/28/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Reminder {

    @NSManaged var alertLabelText: String?
    @NSManaged var creationDate: NSDate?
    @NSManaged var isComplete: NSNumber?
    @NSManaged var notes: String?
    @NSManaged var reminderTime: NSDate?
    @NSManaged var title: String?
    @NSManaged var locationLongitude: NSNumber?
    @NSManaged var locationLatitude: NSNumber?

}