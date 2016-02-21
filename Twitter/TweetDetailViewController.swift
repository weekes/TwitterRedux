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
