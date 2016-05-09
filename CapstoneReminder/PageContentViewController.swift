//
//  PageContentViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 5/9/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    
    var pageIndex: Int?
    var headerText: String!
    var bodyText: String!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLabel.text = self.headerText
        self.bodyLabel.text = self.bodyText
        self.headerLabel.alpha = 0.1
        self.bodyLabel.alpha = 0.1
        UIView.animateWithDuration(1.0) { 
            self.headerLabel.alpha = 1.0
            self.bodyLabel.alpha = 1.0
        }
        // Do any additional setup after loading the view.
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
