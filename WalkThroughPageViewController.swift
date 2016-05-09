//
//  WalkThroughPageViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 5/9/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class WalkThroughPageViewController: UIPageViewController {
    
    let first = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FirstViewController")
    let second = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondViewController")
    
    var orderedViewControllers: [UIViewController] {
        return [first, second]
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstVC = orderedViewControllers.first {
            setViewControllers([firstVC], direction: .Forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    private(set) lazy var orderedViewControllers: [UIViewController] = {
    //        let first = newViewController("First")
    //        let second = newViewController("Second")
    //        return [first, second]
    //
    //
    //    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(name)ViewController")
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

extension WalkThroughPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}
