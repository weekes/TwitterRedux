//
//  Tweet.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

struct Tweet {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: NSDictionary
    
    static func tweetsWithArray(array: [NSDictionary]) -> [Tweet]? {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary;
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        // TODO: use static NSDateFormatter
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
}
