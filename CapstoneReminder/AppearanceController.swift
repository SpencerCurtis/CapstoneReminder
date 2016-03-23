//
//  AppearanceController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 3/23/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit

class AppearanceController {
    
    static func initializeAppearanceDefaults() {
        UISegmentedControl.appearance().tintColor = UIColor.customCyanColor()
        UITextView.appearance().layer.borderWidth = 1
        UITextView.appearance().layer.cornerRadius = 20
    
    }
    
    
}

