//
//  ReminderListTableViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import CoreLocation

class ReminderListTableViewController: UITableViewController, CLLocationManagerDelegate  {
    
    static let sharedController = ReminderListTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 58
        LocationController.sharedController.locationManager.delegate = self
        LocationController.sharedController.checkForRemindersOutsideOfRadius()
        let status = CLLocationManager.authorizationStatus()
        if status == .AuthorizedAlways {
            LocationController.sharedController.locationManager.startUpdatingLocation()
            LocationController.sharedController.locationManager.startMonitoringSignificantLocationChanges()
        }
        if LocationController.sharedController.remindersUsingLocationCount >= 1 {
            LocationController.sharedController.locationManager.startUpdatingLocation()
            LocationController.sharedController.locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderController.sharedController.incompleteReminders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath) as! ReminderTableViewCell
        //                ReminderController.sharedController.reminders.sortInPlace({})
        let reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
        cell.delegate = self
        cell.updateWithReminder(reminder)
        if let bool = reminder.isComplete?.boolValue {
            cell.updateButton(bool)
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
            //            ReminderController.sharedController.in
            ReminderController.sharedController.removeReminder(reminder)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editReminder" {
            let dvc = segue.destinationViewController as? ReminderDetailViewController
            
            if let ReminderDetailViewController = dvc {
                _ = ReminderDetailViewController.view
                
                if let selectedRow = tableView.indexPathForSelectedRow?.row {
                    ReminderDetailViewController.updateWithReminder(ReminderController.sharedController.incompleteReminders[selectedRow])
                }
            }
        }
    }
    
    // MARK: - Location
    
    
}

extension ReminderListTableViewController: ReminderTableViewCellDelegate {
    
    func reminderCellTapped(checkboxButton: UIButton, sender: ReminderTableViewCell) {
        let indexPath = tableView.indexPathForCell(sender)!
        let reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
        
        if checkboxButton.selected.boolValue == false {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                reminder.isComplete = true
                //                checkboxButton.selected = true
                LocationController.sharedController.remindersUsingLocationCount -= 1
                self.tableView.reloadData()
            })
        } else if checkboxButton.selected.boolValue == true {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                reminder.isComplete = false
                checkboxButton.selected = false
                self.tableView.reloadData()
            })
            
        }
        
        ReminderController.sharedController.saveToPersistentStorage()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
}

