//
//  ProfileHeaderView.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/27/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet weak private var profileImage: UIImageView!
    @IBOutlet weak private var username: UILabel!
    @IBOutlet weak private var screenName: UILabel!
    @IBOutlet weak private var profileDescription: UILabel!
    @IBOutlet weak private var location: UILabel!
    @IBOutlet weak private var url: UILabel!
    
    @IBOutlet weak var statusesCountLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    var user: User! {
        didSet {
            if let user = User.currentUser {
                
                if let urlString = user.profileImageUrlString {
                    if let imageURL = NSURL(string: urlString) {
                        profileImage.setImageWithURL(imageURL)
                    }
                }
                username.text = user.name
                screenName.text = "@\(user.screenname!)"
                profileDescription.text = user.tagline
                location.text = user.location
                url.text = user.urlString
                
                statusesCountLabel.text = String(user.statuses_count!)
                friendsCountLabel.text = String(user.friends_count!)
                followersCountLabel.text = String(user.followers_count!)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileDescription.preferredMaxLayoutWidth = profileDescription.bounds.width
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let profileImage = profileImage {
            profileImage.layer.cornerRadius = 4
            profileImage.clipsToBounds = true
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
