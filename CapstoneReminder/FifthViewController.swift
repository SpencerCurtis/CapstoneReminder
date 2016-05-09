//
//  FifthViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 5/9/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(registerForNotifications), userInfo: nil, repeats: false)
        let _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(requestLocationAuthorization), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestLocationAuthorization() {
        LocationController.sharedController.requestAuthorization()
    }
    
    func registerForNotifications() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
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
