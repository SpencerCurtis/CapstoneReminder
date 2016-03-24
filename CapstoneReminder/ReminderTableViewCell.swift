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
    
    var delegate: ReminderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
protocol ReminderTableViewCellDelegate {
    func reminderCellTapped(sender: ReminderTableViewCell)
}


extension ReminderTableViewCell {
    func updateWithReminder(reminder: Reminder) {
        titleLabel.text = reminder.title
        noteLabel.text = reminder.notes
        alertLabel.text = reminder.alertLabelText
        
    }
}