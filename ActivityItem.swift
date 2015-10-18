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
    case Regular = 83.0
    case Tall = 126.0
}

enum ActivityState: Int {
    case Confirmed = 1
    case Denied = -1
}


class ActivityItem {
    
    private var title: String
    private var description: String
    private var streakCount: Int
    private var confirmQueue: [NSDate]
    private var confirmString: String?
    private var lastUpdatedDates:[NSDate]
    private var displayMode: Int
    private var displayHeight: CGFloat
    private var lastPrompt: Bool
    
    
    init(title: String, description: String, baseDate: NSDate, streakCount: Int) {
        self.title = title
        self.description = description
        self.streakCount = streakCount
        confirmQueue = [NSDate]()
        lastUpdatedDates = [NSDate]()
        lastUpdatedDates.append(baseDate)
        displayMode = DisplayMode.ViewActivity.rawValue
        displayHeight = DisplayHeight.Regular.rawValue
        lastPrompt = false
        //print("TESTING current baseDate = \(lastUpdatedDates[lastUpdatedDates.count-1])")
        buildConfirmQueue()
        ActivityItem.scheduleLocalNotification(self.title, fireDate: lastUpdatedDates[lastUpdatedDates.count-1])
        updateDisplayMode()
        
    }
    
    init(title: String, description: String, preferredTime: NSDate) {
        self.title = title
        self.description = description
        displayHeight = DisplayHeight.Regular.rawValue
        streakCount = 0
        confirmQueue = [NSDate]()
        displayMode = DisplayMode.ViewActivity.rawValue
        lastPrompt = false
        
        //setting base date to 3 days previous, for testing purposes
        let daySpan = 24 * 60 * 60 as NSTimeInterval
        lastUpdatedDates = [NSDate]()
        lastUpdatedDates.append(NSDate(timeIntervalSinceNow: -daySpan*3))
        setPreferredTimeOnBaseDate(preferredTime)
        buildConfirmQueue()
        
        //print("TESTING current baseDate = \(lastUpdatedDates[lastUpdatedDates.count-1])")
        
        ActivityItem.scheduleLocalNotification(self.title, fireDate: lastUpdatedDates[lastUpdatedDates.count-1])
        updateDisplayMode()
    }
    
    
    
    //# MARK: - Get 
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
    
    func getConfirmString() -> String? {
        return confirmString
    }
    
    //#MARK: - Set 
    func setDisplayHeight(height: CGFloat) {
        displayHeight = height
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
            //print("TESTING Updating basedate to reflect preferredtime. baseDate set to \(newBaseDate)")
            lastUpdatedDates.append(newBaseDate)
        }
        
        
    }
    
    func getPreferredTimeString() -> String {
        let baseDate = lastUpdatedDates[lastUpdatedDates.count-1]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(baseDate)
    }
    
    func resetConfirmString() {
        confirmString = nil
    }
    
    //# MARK: - ConfirmQueue 
    func dequeueConfirmString() -> String? {
        
        var cs: String?
        
        if confirmString == nil && confirmQueue.count > 0 {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            dateFormatter.timeZone = NSTimeZone()
            
            let dateString = dateFormatter.stringFromDate(confirmQueue[0])
            lastUpdatedDates.append(confirmQueue.removeAtIndex(0))
            
            //print("TESTING Adding \(dateString) to lastUpdatedDates array")
            confirmString = "Did you \(title) on \(dateString)?"
            
            cs = confirmString
            
        } else if confirmString != nil && confirmQueue.count > 0 {
            cs = confirmString
        } else {
            cs = confirmString
        }
        
        print("Dequeuing \(confirmString) from confirmQueue for activity: \(self.title)")
        return cs
    }
    
/*func dequeueConfirmString() -> String? {

if confirmQueue.count > 0 {

if let cs = confirmString {
return cs
} else {//only dispatch new confirmString if the last one was used and reset to nil
let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "MM/dd"
dateFormatter.timeZone = NSTimeZone()

let dateString = dateFormatter.stringFromDate(confirmQueue[0])
lastUpdatedDates.append(confirmQueue.removeAtIndex(0))

//print("TESTING Adding \(dateString) to lastUpdatedDates array")
confirmString = "Did you \(title) on \(dateString)?"

return confirmString
}
}

confirmString = nil
return confirmString
}*/

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
    
    /*func switchDisplayMode() {
        
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
    }*/
    
    //#MARK: - Miscellaneous
    func update(activityIndex: Int, activityState: Int) {
        
        if activityState == ActivityState.Confirmed.rawValue {
            addToStreak()
        } else {
            resetStreak()
        }
        
        confirmString = nil
        updateDisplayMode()
        let aData = ActivityData.sharedInstance
        aData.updateActivityInCoreData(activityIndex)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: activityIndex)
    }
    
    func updateDisplayMode() {
        
        if let _ = getConfirmString() {
            print("updateDisplayMode is executing and setting mode to confirm")
            displayMode = DisplayMode.ConfirmActivity.rawValue
            displayHeight = DisplayHeight.Tall.rawValue
        } else if confirmQueue.count > 0 {
            print("updateDisplayMode is executing and were setting confirm mode!")
            displayMode = DisplayMode.ConfirmActivity.rawValue
            displayHeight = DisplayHeight.Tall.rawValue
        }
        else {
            print("updateDisplayMode is executing without any confirmString - mode set to view")
            displayMode = DisplayMode.ViewActivity.rawValue
            displayHeight = DisplayHeight.Regular.rawValue
        }
        
        /*if confirmQueue.count > 0 {
        displayMode = DisplayMode.ConfirmActivity.rawValue
        displayHeight = DisplayHeight.Tall.rawValue
        } else {
        displayMode = DisplayMode.ViewActivity.rawValue
        displayHeight = DisplayHeight.Regular.rawValue
        }*/
    }
    
    //Deprecated
    /*func reset(activityIndex: Int) {
        resetStreak()
        updateDisplayMode()
        let aData = ActivityData.sharedInstance
        aData.updateActivityInCoreData(activityIndex)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: self)
    }*/
    
    func addToStreak() {
        streakCount++
    }
    
    func resetStreak() {
        streakCount = 0
    }
    
    static func capitalizeEntireString(string: String) -> String {
        var result: String = ""
        var temp: String
        for char in string.characters {
            temp = String(char)
            result += temp.capitalizedString
        }
        
        return result
    }
    
    //#MARK: - UILocalNotification 
    static func scheduleLocalNotification(activityTitle: String, fireDate: NSDate) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.alertBody = "Did you \(activityTitle) today?"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        localNotification.repeatInterval = NSCalendarUnit.Day
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
}