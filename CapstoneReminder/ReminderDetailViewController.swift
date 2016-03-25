//
//  ReminderDetailViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class ReminderDetailViewController: UIViewController {
    
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
        updateReminder()
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func updateReminder() {
        let title = titleTextField.text
        let notes = notesTextView.text
        let reminderTime = alertDatePicker.date
        
        if let reminder = self.reminder {
            reminder.title = title
            reminder.notes = notes
            reminder.alertLabelText = "\(reminderTime)"
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
    
}
