//
//  ActivityItem.swift
//  Streaker
//
//  Created by Chris Larkin on 10/5/15.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit



class ActivityItem {
    
    private var title:String
    private var description:String
    private var streakCount:Int
    private var preferredTime:NSDate
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
        preferredTime = NSDate()
        displayMode = DisplayMode.ViewActivity.rawValue
        displayHeight = 80.0
        buildConfirmQueue()
        
        print("TESTING... current baseDate = \(baseDate.description)")
        
        if confirmQueue.count > 0 {
            switchDisplayMode()
        }
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        displayHeight = 80.0
        //setting base date to 3 days previous, for testing purposes
        let daySpan = 24 * 60 * 60 as NSTimeInterval
        lastUpdatedDates = [NSDate]()
        lastUpdatedDates.append(NSDate(timeIntervalSinceNow: -daySpan*3))
        streakCount = 0
        confirmQueue = [NSDate]()
        preferredTime = NSDate()
        displayMode = DisplayMode.ViewActivity.rawValue
        buildConfirmQueue()
        
        print("TESTING... current baseDate = \(lastUpdatedDates[lastUpdatedDates.count-1])")
        
        if confirmQueue.count > 0 {
            switchDisplayMode()
        }
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
    
    func getLastConfirmedDate() -> NSDate {
        return lastUpdatedDates[lastUpdatedDates.count-1]
    }
    
    //# MARK: - ConfirmQueue Methods
    func dequeueConfirmString() -> String? {
        if confirmQueue.count > 0 {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            dateFormatter.timeZone = NSTimeZone()
            
            let dateString = dateFormatter.stringFromDate(confirmQueue[0])
            print("Adding \(dateString) to lastUpdatedDates array")
            lastUpdatedDates.append(confirmQueue.removeAtIndex(0))
            
            return "Did you \(title) on \(dateString)?"
        }
        
        return nil
    }
    
    func buildConfirmQueue() {
        
        let daySpan = 24 * 60 * 60
        var ctr = 0
        let numDays = calculateDaysSinceUpdated()
        
        while (ctr <= numDays) {
            
            let confirmDate = NSDate(timeInterval: NSTimeInterval(ctr*daySpan), sinceDate: getBaseDate())
            print("Testing... Adding \(confirmDate) to confirmQueue")
            confirmQueue.append(confirmDate)
            ctr++
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
        
        print("TESTING... days since updated = \(diff.day)")
        return diff.day
    }
    
    
    
}