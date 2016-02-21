//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/20/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    // set by the presenting controller
    var tweet: Tweet!
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var screennameLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var tweetTextLabel: UILabel!
    @IBOutlet private weak var retweetsLabel: UILabel!
    @IBOutlet private weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet private weak var retweetButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = tweet.user
        if let urlString = user?.profileImageUrlString {
            if let imageURL = NSURL(string: urlString) {
                profileImageView.setImageWithURL(imageURL)
                profileImageView.layer.cornerRadius = 4
                profileImageView.clipsToBounds = true
            }
        }
        usernameLabel.text = user?.name
        screennameLabel.text = "@\(user!.screenname!)"

        tweetTextLabel.text = tweet.text
        timestampLabel.text = tweet.absoluteTimestamp
        
        retweetsLabel.text = "\(tweet.retweetCount!) RETWEETS"
        favoritesLabel.text = "\(tweet.favoriteCount!) FAVORITES"

        if tweet.favorited! == true {
            // FIXME: need to change the color of the actual button image
            likeButton.imageView?.backgroundColor = UIColor.redColor()
        }
        
        if tweet.retweeted! == true {
            // FIXME: need to change the color of the actual button image
            retweetButton.imageView?.backgroundColor = UIColor.redColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onFavoriteTweet(sender: UIButton) {
        let tweetId = tweet.id
        let params = ["id": tweetId!]
        TwitterClient.sharedInstance.favoriteTweetWithParams(params) { (success, error) -> () in
            print("you just favorited tweet: \(tweetId)")
        }
    }
    
    @IBAction func onRetweetTweet(sender: UIButton) {
        let tweetId = tweet.id
        let params = ["id": tweetId!]
        TwitterClient.sharedInstance.retweetTweetWithParams(tweetId!, params: params) { (success, error) -> () in
            print("you just retweeted tweet: \(tweetId)")
        }
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
