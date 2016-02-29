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
    
    var tweets = [Tweet]()
    var profileUserId: Int?
    
    @IBOutlet private weak var tableView: UITableView!
    private var profileHeaderView: ProfileHeaderView!
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
        
        profileHeaderView = NSBundle.mainBundle().loadNibNamed("ProfileHeaderView", owner: self, options: nil).first as? ProfileHeaderView
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        refreshTweets()
        
        if timelineType != .User {
            tableView.tableHeaderView?.hidden = true
            tableView.tableHeaderView = nil
        } else {
            configureProfileHeaderView()
            tableView.tableHeaderView = profileHeaderView
            tableView.tableHeaderView!.layoutIfNeeded()
            tableView.tableHeaderView!.hidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeHeaderView()
    }
    
    // Needed to resize the header to the correct (i.e. compressed) height
    private func resizeHeaderView() {
        if let headerView = tableView.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            tableView.tableHeaderView = headerView
        }
    }
    
    // MARK: - API Access

    func refreshTweets() {
        var params = ["contributor_details":"true"]
        if let user_id = profileUserId {
            params["user_id"] = String(user_id)
        }
        insertTweets(timelineType, params: params)
    }
    
    private func loadAdditionalTweets() {
        var params = ["contributor_details":"true"]
        if let user_id = profileUserId {
            params["user_id"] = String(user_id)
        }
        if let max_id = tweets.last?.id {
            params["max_id"] = String(max_id)
        }
        appendTweets(timelineType, params: params)
    }
    
    private func insertTweets(type: TimelineType, params: NSDictionary?) {
        fetchTweets(type, params: params, insert: true)
    }
    
    private func appendTweets(type: TimelineType, params: NSDictionary?) {
        fetchTweets(type, params: params, insert: false)
    }
    
    private func fetchTweets(type: TimelineType, params: NSDictionary?, insert: Bool) {
        TwitterClient.sharedInstance.timelineWithParams(type, params: params) { (tweets, error) -> () in
            self.loadingAdditionalTweets = false
            if let newTweets = tweets {
                if insert {
                    self.tweets.insertContentsOf(newTweets, at: 0)
                } else {
                    self.tweets.appendContentsOf(newTweets)
                }
            }
            
            self.tableView.reloadData()
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func configureProfileHeaderView() {
        if profileUserId == nil {
            profileUserId = User.currentUser?.id
        }
        if let user_id = profileUserId {
            let params = ["user_id": String(user_id)]
            TwitterClient.sharedInstance.getUserWithParams(params, completion: { (user, error) -> () in
                self.profileHeaderView.user = user
            })
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
            self.tweets.insert(freshTweet, atIndex: 0)
            
            // reload
            self.tableView.reloadData()
        }
    }
    
    func onProfileImageTap(sender: UITapGestureRecognizer) {
        if let user_id = sender.view?.tag {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tweetsVC = mainStoryboard.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
            
            tweetsVC.timelineType = .User
            tweetsVC.profileUserId = user_id
            self.navigationController?.pushViewController(tweetsVC, animated: true)
        }
    }
    
}


// MARK: - UITableViewDataSource
extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        
        if let user_id = tweet.user?.id {
            cell.profileImageView.tag = user_id
            cell.profileImageView.userInteractionEnabled = true
            
            let profileImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onProfileImageTap:")
            profileImageTapGestureRecognizer.numberOfTapsRequired = 1
            cell.profileImageView.addGestureRecognizer(profileImageTapGestureRecognizer)
            
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