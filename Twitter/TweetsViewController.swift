//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/18/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    enum TimelineType: String {
        case Home = "Home"
        case User = "Profile"
        case Mentions = "Mentions"
    }
    
    var tweets: [Tweet]?
    
    @IBOutlet private weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    private var loadingAdditionalTweets = false
    
    var timelineType: TimelineType = .Home {
        didSet {
            self.navigationItem.title = timelineType.rawValue
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        refreshTweets()
    }
    
    // MARK: - API Access

    func refreshTweets() {
        let params = ["contributor_details":"true"]
        fetchTweets(timelineType, params: params)
    }
    
    private func loadAdditionalTweets() {
        var params = ["contributor_details":"true"]
        if let max_id = tweets?.last?.id {
            params["max_id"] = String(max_id)
            fetchTweets(timelineType, params: params)
        }
    }
    
    private func fetchTweets(type: TimelineType, params: NSDictionary?) {
        TwitterClient.sharedInstance.timelineWithParams(type, params: params) { (tweets, error) -> () in
            self.loadingAdditionalTweets = false
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
        var params = ["status": tweetText]
        
        if let replyToStatusId = composeTweetVC.replyToStatusId {
            let replyId = String(replyToStatusId)
            print("this is a reply to \(replyId)")
            
            params["in_reply_to_status_id"] = String(replyToStatusId)
        }
        
        TwitterClient.sharedInstance.composeTweetWithCompletion(params) { (success, error) -> () in
            // insert at front of tweets array
            let freshTweet = Tweet(user: User.currentUser!, text: tweetText)
            self.tweets?.insert(freshTweet, atIndex: 0)
            
            // reload
            self.tableView.reloadData()
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

// MARK: - UIScrollViewDelegate
extension TweetsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !loadingAdditionalTweets {
            // determine height of tableView and threshold for requesting more tweets
            let scrollViewContentHeight = tableView.contentSize.height
            let additionalDataThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > additionalDataThreshold && (tableView.dragging) {
                loadingAdditionalTweets = true
                loadAdditionalTweets()
            }
        }
    }
}