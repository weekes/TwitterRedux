//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/25/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak private var menuView: UIView!
    @IBOutlet weak private var contentView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    private var originalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet(previousMenuViewController) {
            // a bit of a hack, invoke lazy property `view` to call viewDidLoad()
            view.layoutIfNeeded()
            
            if let oldVC = previousMenuViewController {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.didMoveToParentViewController(nil)
            }

            menuViewController.willMoveToParentViewController(self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMoveToParentViewController(self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(previousContentViewController) {
            // invoke lazily
            view.layoutIfNeeded()
    
            if let oldVC = previousContentViewController {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.didMoveToParentViewController(nil)
            }
            
            // FIXME: why do I have to do this?!!!
            contentViewController.view.frame = self.contentView.bounds
            
//            addChildViewController(contentViewController)
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)

            closeMenu()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPan(panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMarginConstraint.constant
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {

            UIView.animateWithDuration(0.4, animations: {
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                
                // parent of constraints being updated
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    private func openMenu() {
        UIView.animateWithDuration(0.4, animations: {
            // FIXME: Magic number
            self.leftMarginConstraint.constant = self.view.frame.size.width - 50
            // parent of constraints being updated
            self.view.layoutIfNeeded()
        })
    }
    
    private func closeMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.leftMarginConstraint.constant = 0
            // parent of constraints being updated
            self.view.layoutIfNeeded()
        })
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
