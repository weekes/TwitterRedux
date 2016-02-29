//
//  Tweet.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Tweet {
    
    var user: User?
    let id: Int?
    var text: String?
    var createdAtString: String?
    let retweetCount: NSNumber?
    let favoriteCount: NSNumber?
    
    let favorited: Bool?
    let retweeted: Bool?
    
    var json: JSON?
    
    private static var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        return dateFormatter
    }()
    
    private static var absoluteDateFormatter: NSDateFormatter = {
        let absoluteDateFormatter = NSDateFormatter()
        absoluteDateFormatter.timeStyle = .NoStyle
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
            let tweetJSON = JSON(dictionary)
            tweets.append(Tweet(json: tweetJSON))
        }
        
        return tweets
    }

    init(json: JSON) {
        self.json = json
        
        user            = User(json: json["user"])
        id              = json["id"].int
        text            = json["text"].string
        createdAtString = json["created_at"].string
        retweetCount    = json["retweet_count"].number
        favoriteCount   = json["favorite_count"].number
        
        favorited       = json["favorited"].bool ?? false
        retweeted       = json["retweeted"].bool ?? false
    }
    
    init(user: User, text: String) {
        // TODO: what is a good id to represent "not yet server recognized"? (-1, 0, nil?)
        self.init(json: nil)
        self.user = user
        self.text = text
        self.createdAtString = Tweet.dateFormatter.stringFromDate(NSDate())
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
