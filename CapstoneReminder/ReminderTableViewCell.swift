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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        if let delegate = delegate {
            delegate.reminderCellTapped(checkboxButton, sender: self)
        }
    }
    
    func updateButton(_ isComplete: Bool) {
        
        if isComplete == true {
            checkboxButton.setImage(UIImage(named: "checkedBox") ?? UIImage(), for: UIControlState())
        } else if isComplete == false {
            checkboxButton.setImage(UIImage(named: "uncheckedBox") ?? UIImage(), for: UIControlState())
        }
    }
    
}
protocol ReminderTableViewCellDelegate {
    func reminderCellTapped(_ checkboxButton: UIButton, sender: ReminderTableViewCell)
}


extension ReminderTableViewCell {
    func updateWithReminder(_ reminder: Reminder) {
        titleLabel.text = reminder.title
        noteLabel.text = reminder.notes
        alertLabel.text = reminder.alertLabelText
        if let isComplete = reminder.isComplete {
            updateButton(isComplete.boolValue)
        }
    }
}
