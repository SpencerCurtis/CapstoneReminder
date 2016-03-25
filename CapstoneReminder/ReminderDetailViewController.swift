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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTextView()
        // Do any additional setup after loading the view.
        let control = UISegmentedControl()
        if control.selectedSegmentIndex == 0 {
            
        }
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
            locationManager.startUpdatingLocation()
            remindersUsingLocationCount += 1
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
        let title = titleTextField.text
        let notes = notesTextView.text
        let reminderTime = alertDatePicker.date
        
        if let reminder = self.reminder {
            reminder.title = title
            reminder.notes = notes
            reminder.alertLabelText = "\(reminderTime)"
            ReminderController.sharedController.saveToPersistentStorage()
        } else {
            if let title = titleTextField.text {
                let newReminder = Reminder(title: title, notes: notes, reminderTime: reminderTime)
                //                let newReminder = Reminder(title: title, notes: notesTextView.text, isComplete: false)
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
            reminder.alertLabelText = "\(alertDatePicker.date)"
        } else {
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
    
    
    // MARK: - Location
    
    var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    var remindersUsingLocationCount: Int = 0 {
        didSet {
            if remindersUsingLocationCount == 0 {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.last
        }
        if let currentLocation = currentLocation {
            if locations.last?.distanceFromLocation(currentLocation) > 10 {
                let notification = UILocalNotification()
                notification.alertBody = "Check your reminders!"
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                remindersUsingLocationCount -= 1
            }
        }
    }
}





}
