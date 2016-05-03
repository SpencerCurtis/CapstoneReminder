//
//  ReminderTableViewCell.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    var delegate: ReminderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        checkboxButton.setImage(UIImage(named: "canvas1"), forState: .Normal)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        if let delegate = delegate {
            delegate.reminderCellTapped(checkboxButton, sender: self)
        }
    }
    
    func updateButton(isComplete: Bool) {
        
        if isComplete == true {
            checkboxButton.setImage(UIImage(named: "canvas0-1") ?? UIImage(), forState: .Normal)
        } else if isComplete == false {
            checkboxButton.setImage(UIImage(named: "canvas1-1") ?? UIImage(), forState: .Normal)
        }
    }
    
}
protocol ReminderTableViewCellDelegate {
    func reminderCellTapped(checkboxButton: UIButton, sender: ReminderTableViewCell)
}


extension ReminderTableViewCell {
    func updateWithReminder(reminder: Reminder) {
        titleLabel.text = reminder.title
        noteLabel.text = reminder.notes
        alertLabel.text = reminder.alertLabelText
        if let isComplete = reminder.isComplete {
            updateButton(isComplete.boolValue)
        }
    }
}