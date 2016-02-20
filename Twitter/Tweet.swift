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
    
    var relativeTimestamp: String? {
        return Tweet.convertDateToRelativeTimestamp(createdAtDate!)
    }
    
    var createdAtDate: NSDate? {
        return Tweet.dateFormatter.dateFromString(createdAtString!)
    }
    
    private static func convertDateToRelativeTimestamp(date: NSDate) -> String? {
        return Tweet.relativeDateFormatter.stringFromDate(date)
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
    }

}
