//
//  TwitterClient.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import SwiftyJSON

let twitterConsumerKey = "RqDPeHHUGNGvReV2iTDFC0OhA"
let twitterConsumerSecret = "G65zYeZ20XbEwaLTkqjdICca1WP2tArSPSsgd9KRNVGfHQORzh"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func timelineWithParams(type: TweetsViewController.TimelineType, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        let timelineEndpoint: String
        switch type {
        case .Home:
            timelineEndpoint = "1.1/statuses/home_timeline.json"
        case .Mentions:
            timelineEndpoint = "1.1/statuses/mentions_timeline.json"
        case .User:
            timelineEndpoint = "1.1/statuses/user_timeline.json"
        }
        
        // GET the timeline
        GET(timelineEndpoint, parameters: params,
            progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                // FAILURE
                print("Unable to retrieve timeline: \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func favoriteTweetWithParams(params: NSDictionary?, completion: (success: Bool, error: NSError?) -> ()) {
        
        // POST favorite
        POST("1.1/favorites/create.json", parameters: params,
            progress: nil,
            success:  { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                completion(success: true, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                //FAILURE
                print("Unable to favorite tweet: \(error)")
                completion(success: false, error: error)
        })
    }
    
    func retweetTweetWithParams(tweetId: NSNumber, params: NSDictionary?, completion: (success: Bool, error: NSError?) -> ()) {
        
        // POST retweet
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: params,
            progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                completion(success: true, error:nil)
        },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                //FAILURE
                print("Unable to retweet tweet: \(error)")
                completion(success: false, error: error)
        })
    }
    
    func composeTweetWithCompletion(params: NSDictionary?, completion: (success: Bool, error: NSError?) -> ()) {
        
        // POST update
        POST("1.1/statuses/update.json", parameters: params,
            progress: nil,
            success:  { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                completion(success: true, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                //FAILURE
                print("Unable to udpate status: \(error)")
                completion(success: false, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        
        // fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token: \(requestToken)")
                
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                print("Got an error when requesting request token")
                self.loginCompletion?(user: nil, error: error)
        })

    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the access token: \(accessToken)!")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                // GET the user
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    progress: nil,
                    success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                        // SUCCESS
                        if let response = response {
                            print("We've got a user: \(response)")
                            let json = JSON(response)
                            let user = User(json: json)
                            User.currentUser = user
                            print("user: \(user.name)")
                            self.loginCompletion?(user: user, error: nil)
                        }
                    },
                    failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                        // FAILURE
                        print("Unable to verify credentials: \(error)")
                        self.loginCompletion?(user: nil, error: error)
                })
                
            },
            failure: { (error: NSError!) -> Void in
                print("Got an error when requesting access token")
                self.loginCompletion?(user: nil, error: error)
        })
        

    }

}
