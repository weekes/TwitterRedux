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
    let favoriteCount: NSNumber?
    
    private static var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        return dateFormatter
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
        return date.formatAsTimeAgo()
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
        favoriteCount = dictionary["favorite_count"] as? NSNumber ?? 0
    }

}

extension NSDate {
//    let minute = 60
//    let hour = 3600
//    let day = 86400
//    let week = 604800
    
    func formatAsTimeAgo() -> String {
        let secondsSince = Double.abs(self.timeIntervalSinceNow)
        var timeAgo: String
        switch secondsSince {
        case 0..<60:
            let seconds = Int(secondsSince)
            timeAgo = "\(seconds)s" // seconds
        case 60..<3600:
            let minutes = Int(secondsSince / 60)
            timeAgo = "\(minutes)m" // minutes
        case 3600..<86399:
            let hours = Int(secondsSince / 3600)
            timeAgo = "\(hours)h" // hours
        case 86400..<604800:
            let days = Int(secondsSince / 86400)
            timeAgo = "\(days)d" //days
        default:
            timeAgo = Tweet.absoluteDateFormatter.stringFromDate(self)
            
        }
        
        return timeAgo
    }
}
