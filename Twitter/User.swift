//
//  User.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit
import SwiftyJSON

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

struct User {
    
    var name: String?
    var screenname: String?
    var profileImageUrlString: String?
    var tagline: String?
    var location: String?
    var urlString: String?
    var followers_count: Int?
    var friends_count: Int?
    var statuses_count: Int?
    
    var json: JSON
    
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                if let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData {
                    let jsonFromData = JSON(data: data, options: .AllowFragments, error: nil)
                    _currentUser = User(json: jsonFromData)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if let cuser = _currentUser {
                let data: NSData?
                do {
                    data = try cuser.json.rawData()
                } catch _ {
                    data = nil
                }
                
                if let _ = data {
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                }
                
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    init(dictionary: NSDictionary) {
        json = JSON.null
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrlString = dictionary["profile_image_url_https"] as? String
        tagline = dictionary["description"] as? String
    }
    
    init(json: JSON) {
        self.json = json

        name = json["name"].string
        screenname = json["screen_name"].string
        profileImageUrlString = json["profile_image_url_https"].string
        tagline = json["description"].string
        location = json["location"].string
        urlString = json["url"].string
        
        followers_count = json["followers_count"].int
        friends_count = json["friends_count"].int
        statuses_count = json["statuses_count"].int
    }
    
    func login() {
        // User is already logged in at this point
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
}
