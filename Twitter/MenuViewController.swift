//
//  MenuViewController.swift
//  Twitter
//
//  Created by Marcel Weekes on 2/25/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    private var profileNavigationController: UINavigationController!
    private var tweetsNavigationController: UINavigationController!
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
        hamburgerViewController.contentViewController = mentionsNavigationController
    }


    private func setUpMenuItemViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController") as! UINavigationController
        let profileVC = profileNavigationController.topViewController as! TweetsViewController
        profileVC.timelineType = TweetsViewController.TimelineType.User

        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController") as! UINavigationController
        let homeVC = tweetsNavigationController.topViewController as! TweetsViewController
        homeVC.timelineType = TweetsViewController.TimelineType.Home
        
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController") as! UINavigationController
        let mentionsVC = mentionsNavigationController.topViewController as! TweetsViewController
        mentionsVC.timelineType = TweetsViewController.TimelineType.Mentions
        
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(mentionsNavigationController)
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
        return viewControllers.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell")! as UITableViewCell
        cell.textLabel?.text = viewControllerTitles[indexPath.row]
        return cell
    }
}


// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}
