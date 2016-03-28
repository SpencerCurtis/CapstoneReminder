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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 58
//        
//        self.locationManager.delegate = self
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
//    override func viewDidAppear(animated: Bool) {
//        tableView.reloadData()
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ReminderController.sharedController.incompleteReminders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath) as! ReminderTableViewCell
//        ReminderController.sharedController.reminders.sortInPlace({})
        let reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
        cell.delegate = self
        cell.updateWithReminder(reminder)
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let alertLabelText = formatter.stringFromDate(reminder.reminderTime!)
        reminder.alertLabelText = alertLabelText
        cell.alertLabel.text = "At \(alertLabelText)"
        if let bool = reminder.isComplete?.boolValue {
        cell.updateButton(bool)
        
        }
//                        cell.delegate = ReminderTableViewCellDelegate
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
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
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editReminder" {
            let dvc = segue.destinationViewController as? ReminderDetailViewController
            
            if let ReminderDetailViewController = dvc {
                _ = ReminderDetailViewController.view
                
                if let selectedRow = tableView.indexPathForSelectedRow?.row {
                    //Use incomplete Reminders below instead of mockreminders
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
        
        //use incomplete reminders below insteads of mockreminders
        let reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
        
        
        if checkboxButton.selected.boolValue == false {
            reminder.isComplete = true
            checkboxButton.selected = true
            tableView.reloadData()
//            checkboxButton.imageView?.image = UIImage(named: "canvas0")
        } else {
            reminder.isComplete = false
            checkboxButton.selected = false
            
//            checkboxButton.imageView?.image = UIImage(named: "canvas1")

        }
    
        ReminderController.sharedController.saveToPersistentStorage()
        
        tableView.reloadData()
    }
  }

