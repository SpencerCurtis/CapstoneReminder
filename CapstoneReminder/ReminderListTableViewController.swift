//
//  ReminderListTableViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import CoreLocation

class ReminderListTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    static let sharedController = ReminderListTableViewController()
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var reminderFilterSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCount()
        
        self.tableView.tableHeaderView = searchBarView
        self.tableView.contentOffset = CGPointMake(0, 45)
        
        self.tableView.estimatedRowHeight = 58
        //        self.navigationController?.navigationBar.barTintColor = UIColor.customGrayColor()
        self.navigationController?.navigationBar.translucent = true
        
        let status = CLLocationManager.authorizationStatus()
        if status == .AuthorizedWhenInUse  && LocationController.sharedController.remindersUsingLocationCount > 1 {
            LocationController.sharedController.locationManager.requestLocation()
        }
        tableView.reloadData()
        //        self.tableView.backgroundColor = UIColor.lightGrayColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        self.tableView.contentOffset = CGPointMake(0, 45)
        reminderFilterSegmentedControl.selectedSegmentIndex = 0
        
    }
    
    func loadCount() {
        
        for _ in ReminderController.sharedController.incompleteRemindersWithLocationUponArriving {
            LocationController.sharedController.increaseLocationCount()
        }
        for _ in ReminderController.sharedController.incompleteRemindersWithLocationUponLeaving {
            LocationController.sharedController.increaseLocationCount()
        }
    }
    
    @IBAction func remindrFilterSegmentedControlValueChanged(sender: AnyObject) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnInt = 0
        if reminderFilterSegmentedControl.selectedSegmentIndex == 0 {
            returnInt = ReminderController.sharedController.incompleteReminders.count
        } else if reminderFilterSegmentedControl.selectedSegmentIndex == 1 {
            returnInt = ReminderController.sharedController.completeReminders.count
        } else if reminderFilterSegmentedControl.selectedSegmentIndex == 2 {
            returnInt = ReminderController.sharedController.reminders.count
        }
        return returnInt
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath) as! ReminderTableViewCell
        if reminderFilterSegmentedControl.selectedSegmentIndex == 0 {
            let reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
            cell.delegate = self
            cell.updateWithReminder(reminder)
            if let bool = reminder.isComplete?.boolValue {
                cell.updateButton(bool)
            }
        } else if reminderFilterSegmentedControl.selectedSegmentIndex == 1 {
            let reminder = ReminderController.sharedController.completeReminders[indexPath.row]
            cell.delegate = self
            cell.updateWithReminder(reminder)
        } else if reminderFilterSegmentedControl.selectedSegmentIndex == 2 {
            let reminder = ReminderController.sharedController.reminders[indexPath.row]
            cell.delegate = self
            cell.updateWithReminder(reminder)
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
            let reminder = ReminderController.sharedController.reminders[indexPath.row]
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
                    dvc?.reminder = ReminderController.sharedController.reminders[selectedRow]
                    ReminderDetailViewController.updateWithReminder(ReminderController.sharedController.reminders[selectedRow])
                }
            }
        }
    }
    
    
    
    // MARK: - Location
    
    
}



extension ReminderListTableViewController: ReminderTableViewCellDelegate {
    
    func reminderCellTapped(checkboxButton: UIButton, sender: ReminderTableViewCell) {
        let indexPath = tableView.indexPathForCell(sender)!
        var reminder: Reminder?
        if reminderFilterSegmentedControl.selectedSegmentIndex == 0 {
            reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
            if reminderFilterSegmentedControl.selectedSegmentIndex == 1 {
                reminder = ReminderController.sharedController.completeReminders[indexPath.row]
                
            } else if reminderFilterSegmentedControl.selectedSegmentIndex == 2 {
                ReminderController.sharedController.reminders[indexPath.row]
            }
            
            
            if checkboxButton.selected.boolValue == false {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let reminder = reminder {
                        reminder.isComplete = true
                    }
                    LocationController.sharedController.remindersUsingLocationCount -= 1
                    ReminderController.sharedController.saveToPersistentStorage()
                    if let reminder = reminder {
                        RegionController.sharedController.stopMonitoringReminder(reminder)
                    }
                    
                    self.tableView.reloadData()
                    
                })
            } else if checkboxButton.selected.boolValue == true {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let reminder = reminder {
                        reminder.isComplete = false
                    }
                    checkboxButton.selected = false
                    ReminderController.sharedController.saveToPersistentStorage()
                    
                    self.tableView.reloadData()
                    
                })
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
}