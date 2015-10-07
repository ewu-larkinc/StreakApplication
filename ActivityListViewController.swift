//
//  ActivityListViewController.swift
//  Streaker
//
//  Created by Chris Larkin on 10/5/15.
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
        NSNotificationCenter.defaultCenter().removeObserver(self, name: notificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: reloadSelector, name: notificationKey, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        //tableView.reloadData()
        let aData = ActivityData.sharedInstance
        activities = aData.activities
    }
    
    func updateTableView(notification: NSNotification) {
        tableView.reloadData()
    }
    
    //#MARK: - TableView Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let aData = ActivityData.sharedInstance
        let currentItem = aData.activities[indexPath.row]
        
        return currentItem.getDisplayHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! ActivityItemCell
        //let aData = ActivityData.sharedInstance
        let currentActivity = activities[indexPath.row]
        
        print("Testing... adding new cell to tableview")
        
        cell.activityItemIndex = indexPath.row
        cell.titleLabel.text = currentActivity.getTitle()
        cell.descriptLabel.text = currentActivity.getDescription()
        cell.streakLabel.text = String(currentActivity.getStreakCount())
        //cell.promptLabel.text = currentActivity.dequeueConfirmString()
        
        print("New cell item title is \(currentActivity.getTitle())")
        
        if currentActivity.getDisplayMode() == DisplayMode.ViewActivity.rawValue {
            print("Display mode set to View Activity")
            cell.noBtn.hidden = true
            cell.noBtn.enabled = false
            cell.yesBtn.hidden = true
            cell.yesBtn.enabled = false
            cell.promptLabel.hidden = true
            
        } else {
            print("Display mode set to Confirm Activity")
            cell.noBtn.hidden = false
            cell.noBtn.enabled = true
            cell.yesBtn.hidden = false
            cell.yesBtn.enabled = true
            cell.promptLabel.hidden = false
            
            
            var promptText : String
            if let temp = currentActivity.dequeueConfirmString() {
                promptText = currentActivity.capitalizeEntireString(temp)
            } else {
                promptText = currentActivity.getDescription()
            }
            
            cell.promptLabel.text = promptText
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let aData = ActivityData.sharedInstance
        print("Testing... tableview count is \(activities.count)")
        return activities.count
    }
    
}