//
//  ReminderDetailViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import CoreLocation

class ReminderDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var alertTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var alertTimeDatePicker: UIDatePicker!
    
    var alertTimeValue = NSDate?()
    var reminder = Reminder?()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var alertSegmentedControl: UISegmentedControl!
    @IBOutlet weak var alertDatePicker: UIDatePicker!
    
    
    
    @IBAction func UponMovingSegmentedControlTapped(sender: AnyObject) {
        if alertTypeSegmentedControl.selectedSegmentIndex == 1 {
            LocationController.sharedController.requestAuthorization()
            alertDatePicker.hidden = true
        } else if alertTypeSegmentedControl.selectedSegmentIndex == 0 {
            alertDatePicker.hidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTextView()
        // Do any additional setup after loading the view.
        
        //        if UIApplication.sharedApplication().backgroundRefreshStatus == UIBackgroundRefreshStatus.Available {
        //            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(, name: <#T##String?#>, object: <#T##AnyObject?#>)
        //        }
        
        //        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: nil)
        //        let toolbar = UIToolbar().setItems([doneButton], animated: true)
        //        notesTextView.inputAccessoryView = toolbar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editTextView() {
        self.notesTextView.layer.cornerRadius = 8
        self.notesTextView.layer.borderWidth = 0.6
        self.notesTextView.layer.borderColor = UIColor(red: 0.784, green: 0.784, blue: 0.792, alpha: 1.00).CGColor
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if alertSegmentedControl.selectedSegmentIndex == 1 {
            LocationController.sharedController.requestLocation()
            
            
        }
        updateReminder()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func updateReminder() {
        var latitude = LocationController.sharedController.currentLocation?.coordinate.latitude
        var longitude = LocationController.sharedController.currentLocation?.coordinate.longitude
        let title = titleTextField.text
        let notes = notesTextView.text
        let reminderTime = alertDatePicker.date
        
        if let reminder = self.reminder {
            reminder.title = title
            reminder.notes = notes
            if alertSegmentedControl.selectedSegmentIndex == 0 {
            reminder.alertLabelText = "\(reminderTime)"
            } else if alertSegmentedControl.selectedSegmentIndex == 1 {
                reminder.alertLabelText = "Upon Moving"
            }
            ReminderController.sharedController.saveToPersistentStorage()
        } else {
            
            // New Reminders
            let location = LocationController.sharedController.locationManager.location
            latitude = location?.coordinate.latitude
            longitude = location?.coordinate.longitude
            
            if let title = titleTextField.text, latitude = latitude, longitude = longitude {
                
                let newReminder = Reminder(title: title, notes: notes, reminderTime: reminderTime, latitude: latitude, longitude: longitude)
                ReminderController.sharedController.addReminder(newReminder)
                
            }
        }
    }
    
    func updateWithReminder(reminder: Reminder) {
        self.reminder = reminder
        
        
        title = titleTextField.text
        if let title = reminder.title {
            titleTextField.text = title
        }
        if let notes = reminder.notes {
            notesTextView.text = notes
        }
        if alertSegmentedControl.selectedSegmentIndex == 0 {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            let alertLabelText = formatter.stringFromDate(reminder.reminderTime!)
            reminder.alertLabelText = "At \(alertLabelText)"

//            reminder.alertLabelText = "\(alertDatePicker.date)"
        } else if alertSegmentedControl.selectedSegmentIndex == 1 {
            reminder.alertLabelText = "Upon Moving"
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
}






