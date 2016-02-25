//
//  LoginViewController.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

let requestTokenEndpoint = "oauth/request_token"
let authTokenEndpoint = "https://api.twitter.com/oauth/authorize?oauth_token"

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogin(sender: UIButton) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if let _ = user {
                // successful login
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle log in error
            }
        }
    }
}

