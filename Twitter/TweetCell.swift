//
//  TweetCell.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/19/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var screennameLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var tweetTextLabel: UILabel!
    @IBOutlet private weak var explanationLabel: UILabel!
    

    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                if let urlString = user.profileImageUrlString {
                    if let imageURL = NSURL(string: urlString) {
                        profileImageView.setImageWithURL(imageURL)
                    }
                }
                usernameLabel.text = user.name
                screennameLabel.text = "@\(user.screenname!)"
            }
            
            timestampLabel.text = tweet.relativeTimestamp
            tweetTextLabel.text = tweet.text
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
    }
    
}
