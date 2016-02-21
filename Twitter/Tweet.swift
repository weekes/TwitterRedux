//
//  Tweet.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

struct Tweet {
    
    let user: User?
    let text: String?
    let createdAtString: String?
    let dictionary: NSDictionary
    let retweetCount: NSNumber?
    let favouritesCount: NSNumber?
    
    private static var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        return dateFormatter
    }()
    
    private static var relativeDateFormatter: NSDateFormatter = {
        let relativeDateFormatter = NSDateFormatter()
        relativeDateFormatter.timeStyle = .ShortStyle
        relativeDateFormatter.doesRelativeDateFormatting = true
        return relativeDateFormatter
    }()
    
    private static var absoluteDateFormatter: NSDateFormatter = {
        let absoluteDateFormatter = NSDateFormatter()
        absoluteDateFormatter.timeStyle = .ShortStyle
        absoluteDateFormatter.dateStyle = .ShortStyle
        absoluteDateFormatter.doesRelativeDateFormatting = false
        return absoluteDateFormatter
    }()
    
    var relativeTimestamp: String? {
        return Tweet.convertDateToRelativeTimestamp(createdAtDate!)
    }
    
    var absoluteTimestamp: String? {
        return Tweet.convertDateToAbsoluteTimestamp(createdAtDate!)
    }
    
    var createdAtDate: NSDate? {
        return Tweet.dateFormatter.dateFromString(createdAtString!)
    }
    
    private static func convertDateToRelativeTimestamp(date: NSDate) -> String? {
        return Tweet.relativeDateFormatter.stringFromDate(date)
    }

    private static func convertDateToAbsoluteTimestamp(date: NSDate) -> String? {
        return Tweet.absoluteDateFormatter.stringFromDate(date)
    }
    
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
        retweetCount = dictionary["retweet_count"] as? NSNumber ?? 0
        favouritesCount = dictionary["favourites_count"] as? NSNumber ?? 0
    }

}
