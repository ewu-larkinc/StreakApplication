//
//  ActivityListViewController.swift
//  Streaker
//
//  Created by Chris Larkin.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit


enum DisplayMode: Int {
    
    case ViewActivity = 1
    case ConfirmActivity = 2
}

class ListActivityViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "ActivityItemCell"
    let reloadSelector = Selector("updateTableView:")
    let notificationKey = "reloadTableViewData"
    var activities = [ActivityItem]()
    
    override func viewDidLoad() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //tableView.backgroundView = UIImageView(image: UIImage(named: "streakBG"))
        NSNotificationCenter.defaultCenter().removeObserver(self, name: notificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: reloadSelector, name: notificationKey, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        let aData = ActivityData.sharedInstance
        activities = aData.activities
        tableView.reloadData()
    }
    
    func updateTableView(notification: NSNotification) {
        tableView.reloadData()
    }
    
    //#MARK: - TableView Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let currentItem = activities[indexPath.row]
        let height = currentItem.getDisplayHeight()
        print("Cell height is \(height)")
        return height
        //return currentItem.getDisplayHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! ActivityItemCell
        let currentActivity = activities[indexPath.row]
        
        cell.activityItemIndex = indexPath.row
        cell.titleLabel.text = currentActivity.getTitle()
        cell.descriptLabel.text = currentActivity.getDescription()
        cell.streakLabel.text = String(currentActivity.getStreakCount())
        cell.remindTimeLabel.text = "@" + currentActivity.getPreferredTimeString()
        
        print("TESTING adding new cell to tableview")
        print("TESTING New cell item title is \(currentActivity.getTitle())")
        
        
        if currentActivity.getDisplayMode() == DisplayMode.ViewActivity.rawValue {
            print("TESTING Display mode set to View Activity")
            cell.noBtn.hidden = true
            cell.noBtn.enabled = false
            cell.yesBtn.hidden = true
            cell.yesBtn.enabled = false
            cell.promptLabel.hidden = true
            
        } else {
            print("TESTING Display mode set to Confirm Activity")
            cell.noBtn.hidden = false
            cell.noBtn.enabled = true
            cell.yesBtn.hidden = false
            cell.yesBtn.enabled = true
            cell.promptLabel.hidden = false
            
            /*guard let confirmString = currentActivity.dequeueConfirmString() else {
                
                currentActivity.updateDisplayMode()
                return cell
            }
            
            cell.promptLabel.text = confirmString*/
            
            //replaced with more intent revealing code above, will remove after testing
            if let confirmString = currentActivity.dequeueConfirmString() {
                cell.promptLabel.text = confirmString
            } else {
                currentActivity.updateDisplayMode()
            }
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let activityData = ActivityData.sharedInstance
            activityData.deleteActivity(indexPath.row)
            activities = activityData.activities
            tableView.reloadData()
        }
        
    }
    
}