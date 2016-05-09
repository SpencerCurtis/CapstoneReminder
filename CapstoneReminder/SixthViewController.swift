//
//  SixthViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 5/9/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class SixthViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animateWithDuration(1.5) {
            self.getStartedButton.alpha = 1
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func getStartedButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstRun")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
