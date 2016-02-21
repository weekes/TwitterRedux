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
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        fetchTweets()
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "tweetDetailsSegue" {
            let cell = sender as! TweetCell
            let detailsVC = segue.destinationViewController as! TweetDetailViewController
            detailsVC.tweet = cell.tweet
        }
        
        if segue.identifier == "composeSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let composeVC = navController.topViewController as! ComposeTweetViewController
            composeVC.user = User.currentUser
        }
    }

    
    // MARK: - Actions
    
    @IBAction func postTweet(sender: UIStoryboardSegue) {
        let composeTweetVC = sender.sourceViewController as! ComposeTweetViewController
        let tweetText = composeTweetVC.tweetContents
        
        let postingUser = User.currentUser
        print("posting tweet on behalf of \(postingUser?.screenname): \(tweetText)")
    }

    @IBAction func onLogout(sender: UIButton) {
        if let user = User.currentUser {
            let alertVC = UIAlertController(title: user.screenname, message: "Are you sure you want to sign out of Twitter?", preferredStyle: .Alert)
            let logoutAction = UIAlertAction(title: "Sign out", style: .Default) { (action) in
                user.logout()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // dismiss
            }
            alertVC.addAction(logoutAction)
            alertVC.addAction(cancelAction)
            
            presentViewController(alertVC, animated: true, completion: nil)
        }
    }
}


// MARK: - UITableViewDataSource
extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        
        if let tweets = tweets {
            let tweet = tweets[indexPath.row]
            cell.tweet = tweet
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension TweetsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}