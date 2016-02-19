//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/18/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            
            // reload tableView
            print("numTweets = \(self.tweets!.count)")
        }
    }

    @IBAction func onLogout(sender: UIButton) {
        let alertVC = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .ActionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .Destructive) { (action) in
            User.currentUser?.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // dismiss
        }
        alertVC.addAction(logoutAction)
        alertVC.addAction(cancelAction)
        
        presentViewController(alertVC, animated: true, completion: nil)
        
    }
}
