//
//  MenuViewController.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/25/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

let NUM_SECTIONS = 2
let TIMELINE_SECTION = 0
let ACCOUNT_SECTION = 1

class MenuViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    private var profileNavigationController: UINavigationController!
    private var homeNavigationController: UINavigationController!
    private var mentionsNavigationController: UINavigationController!
    
    private var viewControllerTitles = ["Profile", "Home", "Mentions"]
    private var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        setUpMenuItemViewControllers()

        // initial view controller
        hamburgerViewController.contentViewController = profileNavigationController
    }


    private func setUpMenuItemViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController") as! UINavigationController
        let profileVC = profileNavigationController.topViewController as! TweetsViewController
        profileVC.timelineType = TweetsViewController.TimelineType.User

        homeNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController") as! UINavigationController
        let homeVC = homeNavigationController.topViewController as! TweetsViewController
        homeVC.timelineType = TweetsViewController.TimelineType.Home
        
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController") as! UINavigationController
        let mentionsVC = mentionsNavigationController.topViewController as! TweetsViewController
        mentionsVC.timelineType = TweetsViewController.TimelineType.Mentions
        
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(homeNavigationController)
        viewControllers.append(mentionsNavigationController)
    }

    private func logoutUser() {
        if let user = User.currentUser {
            let alertVC = UIAlertController(title: user.screenname, message: "Are you sure you want to sign out of Twitter?", preferredStyle: .Alert)
            let logoutAction = UIAlertAction(title: "Sign out", style: .Default) { (action) in
                user.logout()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // dismiss
            }
            alertVC.addAction(logoutAction)
            alertVC.addAction(cancelAction)
            
            hamburgerViewController.presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // account section
        if section == ACCOUNT_SECTION {
            return 1
        }

        return viewControllers.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell")! as UITableViewCell
        
        // account section
        if indexPath.section == ACCOUNT_SECTION {
            cell.textLabel?.text = "Sign out"
        } else {
            cell.textLabel?.text = viewControllerTitles[indexPath.row]
        }
        
        return cell
    }

    // MARK: - static table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUM_SECTIONS
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == TIMELINE_SECTION {
            return "Timelines"
        } else {
            return "Account"
        }
    }
}


// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.section == TIMELINE_SECTION {
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }  else if indexPath.section == ACCOUNT_SECTION {
            logoutUser()
        }
        
    }
}
