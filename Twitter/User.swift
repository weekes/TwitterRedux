//
//  User.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileImageUrlString: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        print("Error creating user from dictionary: \(error)")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if let cuser = _currentUser {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(cuser.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrlString = dictionary["profile_image_ulr"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
}
