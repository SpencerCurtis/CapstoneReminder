    //
//  ReminderDetailViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import CoreLocation

class ReminderDetailViewController: UIViewController, CLLocationManagerDelegate {
    
    static let sharedController = ReminderDetailViewController()
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var updatingLocationView: UIView!
    @IBOutlet weak var alertTimeDatePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var alertSegmentedControl: UISegmentedControl!
    @IBOutlet weak var alertDatePicker: UIDatePicker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var alertTimeValue = NSDate?()
    var reminder = Reminder?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = CLLocationManager.authorizationStatus()
        if status == .AuthorizedAlways {
            LocationController.sharedController.locationManager.startUpdatingLocation()
            LocationController.sharedController.locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    override func viewWillAppear(animated: Bool) {
        editTextView()
        editTextField()
        alertDatePicker.minimumDate = NSDate()
        addToolBar(titleTextField)
        addToolBarForTextView(notesTextView)
        activityIndicator.stopAnimating()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func UponMovingSegmentedControlTapped(sender: AnyObject) {
        if alertSegmentedControl.selectedSegmentIndex == 1 {
            LocationController.sharedController.requestAuthorization()
            
            alertDatePicker.hidden = true
        } else if alertSegmentedControl.selectedSegmentIndex == 0 {
            alertDatePicker.hidden = false
        }
    }
    
    func editTextField() {
        self.titleTextField.layer.cornerRadius = 8
        self.titleTextField.layer.borderWidth = 0.6
        self.titleTextField.layer.borderColor = UIColor(red: 0.784, green: 0.784, blue: 0.792, alpha: 1.00).CGColor
        
    }
    func editTextView() {
        self.notesTextView.layer.cornerRadius = 8
        self.notesTextView.layer.borderWidth = 0.6
        self.notesTextView.layer.borderColor = UIColor(red: 0.784, green: 0.784, blue: 0.792, alpha: 1.00).CGColor
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if alertSegmentedControl.selectedSegmentIndex == 1 && LocationController.sharedController.locations == [] {
            LocationController.sharedController.requestLocations()
            activityIndicator.startAnimating()
            saveButton.enabled = false
            header.backBarButtonItem?.enabled = false
            view.addSubview(activityIndicator)
            updatingLocationView.hidden = false
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stopActivityIndicator), name: "hasLocation", object: nil)
        } else if alertSegmentedControl.selectedSegmentIndex == 1 && LocationController.sharedController.locations != [] {
            updateReminder()
            navigationController?.popViewControllerAnimated(true)
        } else if alertSegmentedControl.selectedSegmentIndex == 0 {
            updateReminder()
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        updateReminder()
        updatingLocationView.hidden = true
        navigationController?.popViewControllerAnimated(true)
    }
    
    func displayAlertForReminder(reminder: Reminder) {
        let alert = UIAlertController(title: reminder.title, message: reminder.notes, preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "Okay", style: .Default) { (alert) in
            
        }
        alert.addAction(doneAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func updateReminder() {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        var latitude = LocationController.sharedController.currentLocation?.coordinate.latitude
        var longitude = LocationController.sharedController.currentLocation?.coordinate.longitude
        
        let title = titleTextField.text
        let notes = notesTextView.text
        var alertLabelText = ""
        let reminderTime = alertDatePicker.date
//        let reminderTimeString = formatter.stringFromDate(reminderTime)
        
        if let reminder = self.reminder {
            reminder.title = title
            reminder.notes = notes
            if alertSegmentedControl.selectedSegmentIndex == 0 {
                let reminderTimeString = formatter.stringFromDate(reminderTime)
                reminder.alertLabelText = "At \(reminderTimeString)"
            } else if alertSegmentedControl.selectedSegmentIndex == 1 {
                reminder.alertLabelText = "Upon Moving"
            }
            ReminderController.sharedController.saveToPersistentStorage()
        } else {
            // New Reminders
            
            let location = LocationController.sharedController.locationManager.location
            latitude = location?.coordinate.latitude
            longitude = location?.coordinate.longitude
            
            // New Reminders
            if alertSegmentedControl.selectedSegmentIndex == 0 {
                if let title = titleTextField.text {
                    
                    let reminderTimeString = formatter.stringFromDate(reminderTime)
                    alertLabelText =  "At \(reminderTimeString)"
                    let newReminder = Reminder(title: title, notes: notes, reminderTime: reminderTime, alertLabelText: alertLabelText)
                    ReminderController.sharedController.addReminder(newReminder)
                    AlarmController.sharedController.sendNotificationForReminderWithTime(newReminder, fireDate: alertTimeDatePicker.date)
                }
            } else if alertSegmentedControl.selectedSegmentIndex == 1, let title = titleTextField.text, let longitude = longitude, let latitude = latitude {
                
                let newReminder = Reminder(title: title, notes: notes, alertLabelText: "Upon Moving", latitude: latitude, longitude: longitude)
                ReminderController.sharedController.addReminder(newReminder)
                LocationController.sharedController.remindersUsingLocationCount += 1
                
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
            if let reminderTime = reminder.reminderTime {
                let alertLabelText = formatter.stringFromDate(reminderTime)
                reminder.alertLabelText = "At \(alertLabelText)"
            }
            //            reminder.alertLabelText = "\(alertDatePicker.date)"
        } else if alertSegmentedControl.selectedSegmentIndex == 1 {
            reminder.alertLabelText = "Upon Moving"
        }
        
    }
}

extension UIViewController: UITextFieldDelegate {
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(UIViewController.donePressed))
        doneButton.tintColor = UIColor.customCyanColor()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
}

extension UIViewController: UITextViewDelegate {
    func addToolBarForTextView(textView: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(UIViewController.donePressedForTextView))
        doneButton.tintColor = UIColor.customCyanColor()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textView.delegate = self
        textView.inputAccessoryView = toolBar
    }
    func donePressedForTextView(){
        view.endEditing(true)
    }
}







