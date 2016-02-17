//
//  TwitterClient.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "RqDPeHHUGNGvReV2iTDFC0OhA"
let twitterConsumerSecret = "G65zYeZ20XbEwaLTkqjdICca1WP2tArSPSsgd9KRNVGfHQORzh"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

}
