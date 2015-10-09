//
//  ActivityItem.swift
//  Streaker
//
//  Created by Chris Larkin.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit



class ActivityItem {
    
    private var title:String
    private var description:String
    private var streakCount:Int
    //private var preferredTime:NSDate
    private var confirmQueue:[NSDate]
    private var lastUpdatedDates:[NSDate]
    private var confirmString:String?
    private var displayMode: Int
    private var displayHeight: CGFloat
    
    
    init(title: String, description: String, baseDate: NSDate, streakCount: Int) {
        self.title = title
        self.description = description
        self.streakCount = streakCount
        //self.preferredTime = preferredTime
        
        confirmQueue = [NSDate]()
        lastUpdatedDates = [NSDate]()
        lastUpdatedDates.append(baseDate)
        displayMode = DisplayMode.ViewActivity.rawValue
        displayHeight = 80.0
        buildConfirmQueue()
        
        print("TESTING current baseDate = \(baseDate.description)")
        
        if confirmQueue.count > 0 {
            switchDisplayMode()
        }
    }
    
    init(title: String, description: String, preferredTime: NSDate) {
        self.title = title
        self.description = description
        //self.preferredTime = preferredTime
        
        displayHeight = 80.0
        //setting base date to 3 days previous, for testing purposes
        let daySpan = 24 * 60 * 60 as NSTimeInterval
        lastUpdatedDates = [NSDate]()
        lastUpdatedDates.append(NSDate(timeIntervalSinceNow: -daySpan*3))
        
        streakCount = 0
        confirmQueue = [NSDate]()
        displayMode = DisplayMode.ViewActivity.rawValue
        setPreferredTimeOnBaseDate(preferredTime)
        buildConfirmQueue()
        
        print("TESTING current baseDate = \(lastUpdatedDates[lastUpdatedDates.count-1])")
        
        if confirmQueue.count > 0 {
            switchDisplayMode()
        }
    }
    
    init() {
        title = ""
        description = ""
        displayHeight = 0.0
        lastUpdatedDates = [NSDate]()
        //preferredTime = NSDate()
        displayMode = DisplayMode.ViewActivity.rawValue
        streakCount = 0
        confirmQueue = [NSDate]()
    }
    
    
    
    //# MARK: - Get Methods
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
    
    /*func getPreferredTime() -> NSDate {
        return preferredTime
    }*/
    
    func getPreferredTimeString() -> String {
        let baseDate = lastUpdatedDates[lastUpdatedDates.count-1]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(baseDate)
    }
    
    //# MARK: - ConfirmQueue Methods
    func dequeueConfirmString() -> String? {
        if confirmQueue.count > 0 {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            dateFormatter.timeZone = NSTimeZone()
            
            let dateString = dateFormatter.stringFromDate(confirmQueue[0])
            lastUpdatedDates.append(confirmQueue.removeAtIndex(0))
            
            print("TESTING Adding \(dateString) to lastUpdatedDates array")
            
            return "Did you \(title) on \(dateString)?"
        }
        
        return nil
    }
    
    func buildConfirmQueue() {
        
        let daySpan = 24 * 60 * 60
        var ctr = 1
        let numDays = calculateDaysSinceUpdated()
        
        while (ctr <= numDays) {
            
            let confirmDate = NSDate(timeInterval: NSTimeInterval(ctr*daySpan), sinceDate: getBaseDate())
            confirmQueue.append(confirmDate)
            ctr++
            
            print("TESTING Adding \(confirmDate) to confirmQueue")
        }
        
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
    
    func setDisplayHeight(height: CGFloat) {
        displayHeight = height
    }
    
    /*func setPreferredTime(date: NSDate) {
        preferredTime = date
    }*/
    
    func setPreferredTimeOnBaseDate(preferredTime: NSDate) {
        
        let baseDate = lastUpdatedDates[lastUpdatedDates.count-1]
        let calendar = NSCalendar.currentCalendar()
        let baseDateComponents = calendar.components([.Day, .Month, .Year], fromDate: baseDate)
        let preferredTimeComponents = calendar.components([.Second, .Minute, .Hour], fromDate: preferredTime)
        
        baseDateComponents.second = preferredTimeComponents.second
        baseDateComponents.minute = preferredTimeComponents.minute
        baseDateComponents.hour = preferredTimeComponents.hour
        
        if let newBaseDate = baseDateComponents.date {
            print("TESTING Updating basedate to reflect preferredtime. baseDate set to \(newBaseDate)")
            lastUpdatedDates.append(newBaseDate)
        }
        
        
    }
    
    //#MARK: - DisplayMode methods
    func switchDisplayMode() {
        
        if displayMode == DisplayMode.ViewActivity.rawValue {
            displayMode = DisplayMode.ConfirmActivity.rawValue
            displayHeight = 120.0
        } else {
            displayMode = DisplayMode.ViewActivity.rawValue
            displayHeight = 80.0
        }
    }
    
    func updateDisplayMode() {
        
        if confirmQueue.count == 0 {
            displayMode = DisplayMode.ViewActivity.rawValue
            displayHeight = 80.0
        } else {
            displayMode = DisplayMode.ConfirmActivity.rawValue
            displayHeight = 120.0
        }
    }
    
    //#MARK: - Misc. methods
    func update() {
        
        addToStreak()
        updateDisplayMode()
        let aData = ActivityData.sharedInstance
        aData.updateActivityInCoreData(self)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: self)
    }
    
    func reset() {
        resetStreak()
        updateDisplayMode()
        let aData = ActivityData.sharedInstance
        aData.updateActivityInCoreData(self)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: self)
    }
    
    func addToStreak() {
        streakCount++
    }
    
    func resetStreak() {
        streakCount = 0
    }
    
    
    func calculateDaysSinceUpdated() -> Int {
        let curDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let diff = calendar.components(NSCalendarUnit.Day, fromDate: getBaseDate(), toDate: curDate, options: NSCalendarOptions.MatchStrictly)
        
        
        print("TESTING days since updated = \(diff.day)")
        return diff.day
    }
    
    
    
}