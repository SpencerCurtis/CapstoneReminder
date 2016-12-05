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
        self.tableView.contentOffset = CGPoint(x: 0, y: 45)
        
        self.tableView.estimatedRowHeight = 58
        self.navigationController?.navigationBar.isTranslucent = true
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse  && LocationController.sharedController.remindersUsingLocationCount > 1 {
            LocationController.sharedController.locationManager.requestLocation()
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.tableView.contentOffset = CGPoint(x: 0, y: 45)
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
    
    @IBAction func remindrFilterSegmentedControlValueChanged(_ sender: AnyObject) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnInt = 0
        if reminderFilterSegmentedControl.selectedSegmentIndex == 0 {
            returnInt = ReminderController.sharedController.incompleteReminders.count
        } else if reminderFilterSegmentedControl.selectedSegmentIndex == 1 {
            returnInt = ReminderController.sharedController.completeReminders.count
        }
        return returnInt
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! ReminderTableViewCell
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
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ReminderController.sharedController.reminders.count > 0 ? UITableViewAutomaticDimension : 58
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminder = ReminderController.sharedController.reminders[indexPath.row]
            ReminderController.sharedController.removeReminder(reminder)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editReminder" {
            let dvc = segue.destination as? ReminderDetailViewController
            
            if let ReminderDetailViewController = dvc {
                _ = ReminderDetailViewController.view
                
                if let selectedRow = tableView.indexPathForSelectedRow?.row {
                    dvc?.reminder = ReminderController.sharedController.reminders[selectedRow]
                    ReminderDetailViewController.updateWithReminder(ReminderController.sharedController.reminders[selectedRow])
                    dvc?.title = "Edit Remindr"
                }
            }
        }
    }
}



extension ReminderListTableViewController: ReminderTableViewCellDelegate {
    
    func reminderCellTapped(_ checkboxButton: UIButton, sender: ReminderTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        var reminder: Reminder?
        
        if reminderFilterSegmentedControl.selectedSegmentIndex == 0 {
            reminder = ReminderController.sharedController.incompleteReminders[indexPath.row]
        } else if reminderFilterSegmentedControl.selectedSegmentIndex == 1 {
            reminder = ReminderController.sharedController.completeReminders[indexPath.row]
        }
        
        
        if checkboxButton.isSelected == false {
            DispatchQueue.main.async(execute: { () -> Void in
                if let reminder = reminder {
                    reminder.isComplete = true
                }
                
                LocationController.sharedController.remindersUsingLocationCount -= 1
                ReminderController.sharedController.saveToPersistentStorage()
                if let reminder = reminder {
                    RegionController.sharedController.stopMonitoringReminder(reminder)
                    ReminderController.sharedController.deleteNotificationForRemindr(reminder)
                }
                
                self.tableView.reloadData()
                
            })
        } else if checkboxButton.isSelected == true {
            DispatchQueue.main.async(execute: { () -> Void in
                if let reminder = reminder {
                    reminder.isComplete = false
                }
                checkboxButton.isSelected = false
                ReminderController.sharedController.saveToPersistentStorage()
                
                self.tableView.reloadData()
                
            })
            
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
        
        
    }
}
