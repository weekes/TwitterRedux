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
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
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


// MARK: - UITableViewDataSource
extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell")! as UITableViewCell // TODO: TweetCell
        
        if let tweets = tweets {
            let tweet = tweets[indexPath.row]
            cell.textLabel!.text = tweet.text
        }
        
        return cell
    }
    
}
