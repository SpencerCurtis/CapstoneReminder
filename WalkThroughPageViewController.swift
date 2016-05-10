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
    let third = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ThirdViewController")
    let fourth = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FourthViewController")
    let fifth = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FifthViewController")
    let sixth = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SixthViewController")
    
    var firstRun: Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("firstRun")
    }
    
    var orderedViewControllers: [UIViewController] {
        return [first, second, third, fourth, fifth, sixth]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        if let firstVC = orderedViewControllers.first {
            setViewControllers([firstVC], direction: .Forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(name)ViewController")
    }
    
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