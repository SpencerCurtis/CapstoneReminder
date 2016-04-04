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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 58
        LocationController.sharedController.locationManager.delegate = self
        LocationController.sharedController.locationManager.startUpdatingLocation() 
        LocationController.sharedController.checkForRemindersOutsideOfRadius()
        
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
        //        ReminderController.sharedController.reminders.sortInPlace({})
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
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Location
    
    
}

extension ReminderListTableViewController: ReminderTableViewCellDelegate {
    
    func reminderCellTapped(checkboxButton: UIButton, sender: ReminderTableViewCell) {
        let indexPath = tableView.indexPathForCell(sender)!
        let reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
        
        if checkboxButton.selected.boolValue == false {
            reminder.isComplete = true
            checkboxButton.selected = true
            LocationController.sharedController.remindersUsingLocationCount -= 1
            tableView.reloadData()
        } else {
            reminder.isComplete = false
            checkboxButton.selected = false
            tableView.reloadData()
        }
        
        ReminderController.sharedController.saveToPersistentStorage()
        
        tableView.reloadData()
    }
}

