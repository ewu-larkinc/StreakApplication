//
//  ActivityItem.swift
//  Streaker
//
//  Created by Chris Larkin.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit

enum DisplayHeight: CGFloat {
    case Regular = 80.0
    case Tall = 120.0
}


class ActivityItem {
    
    private var title:String
    private var description:String
    private var streakCount:Int
    private var confirmQueue:[NSDate]
    private var lastUpdatedDates:[NSDate]
    private var confirmString:String?
    private var displayMode: Int
    private var displayHeight: CGFloat
    
    
    init(title: String, description: String, baseDate: NSDate, streakCount: Int) {
        self.title = title
        self.description = description
        self.streakCount = streakCount
        confirmQueue = [NSDate]()
        lastUpdatedDates = [NSDate]()
        lastUpdatedDates.append(baseDate)
        displayMode = DisplayMode.ViewActivity.rawValue
        displayHeight = DisplayHeight.Regular.rawValue
        buildConfirmQueue()
        
        //isActivityOutOfDate() returns true if baseDate != curDate (disregarding time aspect,eg only day, month, year)
        
        /*if confirmQueue.count > 0 {
            switchDisplayMode()
        }*/
        
        scheduleLocalNotification()
        setDisplayMode()
    }
    
    init(title: String, description: String, preferredTime: NSDate) {
        self.title = title
        self.description = description
        displayHeight = DisplayHeight.Regular.rawValue
        streakCount = 0
        confirmQueue = [NSDate]()
        displayMode = DisplayMode.ViewActivity.rawValue
        
        //setting base date to 3 days previous, for testing purposes
        let daySpan = 24 * 60 * 60 as NSTimeInterval
        lastUpdatedDates = [NSDate]()
        lastUpdatedDates.append(NSDate(timeIntervalSinceNow: -daySpan*3))
        setPreferredTimeOnBaseDate(preferredTime)
        
        //may want to add closure to following method to call setDisplayMode - to guarantee that the buildConfirmQueue method has executed before we check the size of confirm queue to determine the display mode later on
        buildConfirmQueue()
        
        print("TESTING current baseDate = \(lastUpdatedDates[lastUpdatedDates.count-1])")
        
        /*if confirmQueue.count > 0 {
            switchDisplayMode()
        }*/
        
        scheduleLocalNotification()
        setDisplayMode()
    }
    
    
    
    //# MARK: - Get Functions
    func getTitle() -> String {
        return title
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getStreakCount() -> Int {
        return streakCount
    }
    
    func getBaseDate() -> NSDate {
        return lastUpdatedDates[lastUpdatedDates.count-1]
    }
    
    func getDisplayMode() -> Int {
        return displayMode
    }
    
    func getDisplayHeight() -> CGFloat {
        return displayHeight
    }
    
    func getNumDaysSinceUpdated() -> Int {
        let curDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let diff = calendar.components(NSCalendarUnit.Day, fromDate: getBaseDate(), toDate: curDate, options: NSCalendarOptions.MatchStrictly)
        
        
        print("TESTING days since updated = \(diff.day)")
        return diff.day
    }
    
    //#MARK: - Set Functions
    func setDisplayHeight(height: CGFloat) {
        displayHeight = height
    }
    
    func setDisplayMode() {
        if confirmQueue.count > 0 {
            displayMode = DisplayMode.ConfirmActivity.rawValue
            displayHeight = DisplayHeight.Tall.rawValue
        } else {
            displayMode = DisplayMode.ViewActivity.rawValue
            displayHeight = DisplayHeight.Regular.rawValue
        }
    }
    
    func setPreferredTimeOnBaseDate(preferredTime: NSDate) {
        
        let baseDate = lastUpdatedDates[lastUpdatedDates.count-1]
        let calendar = NSCalendar.currentCalendar()
        let baseDateComponents = calendar.components([.Day, .Month, .Year], fromDate: baseDate)
        let preferredTimeComponents = calendar.components([.Second, .Minute, .Hour], fromDate: preferredTime)
        
        baseDateComponents.calendar = calendar
        baseDateComponents.second = preferredTimeComponents.second
        baseDateComponents.minute = preferredTimeComponents.minute
        baseDateComponents.hour = preferredTimeComponents.hour
        
        print("DateComponents contains: \(baseDateComponents.date)")
        
        if let newBaseDate = baseDateComponents.date {
            print("TESTING Updating basedate to reflect preferredtime. baseDate set to \(newBaseDate)")
            lastUpdatedDates.append(newBaseDate)
        }
        
        
    }
    
    func getPreferredTimeString() -> String {
        let baseDate = lastUpdatedDates[lastUpdatedDates.count-1]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(baseDate)
    }
    
    //# MARK: - ConfirmQueue Functions
    func dequeueConfirmString() -> String? {
        if confirmQueue.count > 0 {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            dateFormatter.timeZone = NSTimeZone()
            
            let dateString = dateFormatter.stringFromDate(confirmQueue[0])
            lastUpdatedDates.append(confirmQueue.removeAtIndex(0))
            
            //print("TESTING Adding \(dateString) to lastUpdatedDates array")
            
            return "Did you \(title) on \(dateString)?"
        }
        
        return nil
    }
    
    func buildConfirmQueue() {
        
        let daySpan = 24 * 60 * 60
        var ctr = 1
        let numDays = getNumDaysSinceUpdated()
        
        while (ctr <= numDays) {
            
            let confirmDate = NSDate(timeInterval: NSTimeInterval(ctr*daySpan), sinceDate: getBaseDate())
            confirmQueue.append(confirmDate)
            ctr++
        }
        
    }
    
    //#MARK: - DisplayMode Functions
    func switchDisplayMode() {
        
        if displayMode == DisplayMode.ViewActivity.rawValue {
            displayMode = DisplayMode.ConfirmActivity.rawValue
            displayHeight = DisplayHeight.Tall.rawValue
        } else {
            displayMode = DisplayMode.ViewActivity.rawValue
            displayHeight = DisplayHeight.Regular.rawValue
        }
        
        
    }
    
    func updateDisplayMode() {
        
        if confirmQueue.count == 0 {
            displayMode = DisplayMode.ViewActivity.rawValue
            displayHeight = DisplayHeight.Regular.rawValue
        } else {
            displayMode = DisplayMode.ConfirmActivity.rawValue
            displayHeight = DisplayHeight.Tall.rawValue
        }
    }
    
    //#MARK: - Misc. Functions
    func update(activityIndex: Int) {
        
        addToStreak()
        updateDisplayMode()
        let aData = ActivityData.sharedInstance
        aData.updateActivityInCoreData(activityIndex)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: self)
    }
    
    func reset(activityIndex: Int) {
        resetStreak()
        updateDisplayMode()
        let aData = ActivityData.sharedInstance
        aData.updateActivityInCoreData(activityIndex)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: self)
    }
    
    func addToStreak() {
        streakCount++
    }
    
    func resetStreak() {
        streakCount = 0
    }
    
    func capitalizeEntireString(string: String) -> String {
        var result: String = ""
        var temp: String
        for char in string.characters {
            temp = String(char)
            result += temp.capitalizedString
        }
        
        return result
    }
    
    //#MARK: - UILocalNotification Functions
    func scheduleLocalNotification() {
        let localNotification = UILocalNotification()
        localNotification.fireDate = lastUpdatedDates[lastUpdatedDates.count-1]
        localNotification.alertBody = "Did you \(self.title) today?"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        localNotification.repeatInterval = NSCalendarUnit.Day
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
}