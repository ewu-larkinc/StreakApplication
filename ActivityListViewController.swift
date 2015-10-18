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
        //tableView.beginUpdates()
        //tableView.endUpdates()
        
    }
    
    //#MARK: - UITableView Functions
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let currentItem = activities[indexPath.row]
        print("Cell for \(currentItem.getTitle()) being created with height = \(currentItem.getDisplayHeight())")
        return currentItem.getDisplayHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! ActivityItemCell
        let currentActivity = activities[indexPath.row]
        
        //Using 2 background views here because setting the masksToBounds property to true cancels out the border shadow when applied to the same element. So the content is contained within the top bgView, with masksToBounds set to true, and the underlying bgView has the border shadow applied
        cell.bgView2.layer.shadowOpacity = 0.7
        cell.bgView2.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.bgView2.layer.shadowRadius = 1
        cell.bgView.layer.cornerRadius = 3.0
        cell.bgView2.layer.cornerRadius = 3.0
        cell.bgView.layer.masksToBounds = true
        
        cell.activityItemIndex = indexPath.row
        cell.titleLabel.text = currentActivity.getTitle()
        cell.descriptLabel.text = currentActivity.getDescription()
        cell.streakLabel.text = String(currentActivity.getStreakCount())
        cell.remindTimeLabel.text = "@" + currentActivity.getPreferredTimeString()
        
        
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
            cell.noBtn.layer.shadowOpacity = 0.7
            cell.noBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
            cell.noBtn.layer.shadowRadius = 1
            cell.yesBtn.hidden = false
            cell.yesBtn.enabled = true
            cell.yesBtn.layer.shadowOpacity = 0.7
            cell.yesBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
            cell.yesBtn.layer.shadowRadius = 1
            cell.promptLabel.hidden = false
            
            if let confirmString = currentActivity.dequeueConfirmString() {
                cell.promptLabel.text = confirmString
            } else {
                currentActivity.updateDisplayMode()
                return cell
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