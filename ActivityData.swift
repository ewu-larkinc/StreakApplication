//
//  ActivityData.swift
//  Streaker
//
//  Created by Chris Larkin.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit
import CoreData

private let _SingletonSharedInstance = ActivityData()

class ActivityData {
    
    class var sharedInstance: ActivityData {
        return _SingletonSharedInstance
    }
    
    
    var activities: [ActivityItem]
    var currentlySelectedTime: NSDate?
    var selectedActivity: ActivityItem?
    let entityKeyName = "EntityActivity"
    let entityKeyTitle = "title"
    let entityKeyDescription = "descript"
    let entityBaseCount = "streakCount"
    let entityBaseDate = "baseDate"
    
    init() {
        activities = [ActivityItem]()
    }
    
    //#MARK: - ActivityItem Management
    func addActivity(newItem: ActivityItem) {
        activities.append(newItem)
        saveActivity(newItem)
    }
    
    func deleteActivity(index: Int) -> Bool {
        
        let maxIndex = activities.count-1
        if index < 0 || index > maxIndex {
            return false
        }
        
        deleteFromCoreData(activities[index])
        activities.removeAtIndex(index)
        return true
    }
    
    func setCurrentlySelectedTime(time: NSDate) {
        currentlySelectedTime = time
    }
    
    func getCurrentlySelectedTime() -> NSDate? {
        return currentlySelectedTime
    }
    
    
    //#MARK: - Core Data Functions
    func saveActivity(item: ActivityItem) {
        
        let managedContext = getManagedObjectContext()
        
        let entityDescription = NSEntityDescription.entityForName(entityKeyName, inManagedObjectContext: managedContext)
        let newEntity = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedContext)
        
        newEntity.setValue(item.getTitle(), forKey: entityKeyTitle)
        newEntity.setValue(item.getDescription(), forKey: entityKeyDescription)
        newEntity.setValue(item.getStreakCount(), forKey: entityBaseCount)
        newEntity.setValue(item.getBaseDate(), forKey: entityBaseDate)
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save \(error)")
        }
    }
    
    func getManagedObjectContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    
    func fetchFromCoreData() -> [NSManagedObject] {
        
        let managedContext = getManagedObjectContext()
        let fetchRequest = NSFetchRequest(entityName: entityKeyName)
        let fetchedResults = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        return fetchedResults
    }
    
    func readInFromCoreData() {
        
        let cdItems = fetchFromCoreData()
        print("TESTING Core data count (fetched) is \(cdItems.count)")
        
        for item in cdItems {
            
            let title = item.valueForKey(entityKeyTitle) as! String
            let description = item.valueForKey(entityKeyDescription) as! String
            let lastUpdatedDate = item.valueForKey(entityBaseDate) as! NSDate
            let baseCount = item.valueForKey(entityBaseCount) as! Int
            
            let newActivity = ActivityItem(title: title, description: description, baseDate: lastUpdatedDate, streakCount: baseCount)
            
            activities.append(newActivity)
        }
        
    }
    
    func deleteFromCoreData(item: ActivityItem) {
        
        let managedContext = getManagedObjectContext()
        
        let fetchRequest = NSFetchRequest(entityName: entityKeyName)
        let predicate = NSPredicate(format: "title == %@", item.getTitle())
        fetchRequest.predicate = predicate
        
        let fetchedResult = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        
        managedContext.deleteObject(fetchedResult[0])
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save \(error)")
        }
        
    }
    
    func updateActivityInCoreData(index: Int) {
        
        let managedContext = getManagedObjectContext()
        let item = activities[index]
        
        let fetchRequest = NSFetchRequest(entityName: entityKeyName)
        let predicate = NSPredicate(format: "title == %@", item.getTitle())
        fetchRequest.predicate = predicate
        
        let fetchedResults = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        if fetchedResults.count > 0 {
            
            let title = fetchedResults[0].valueForKey("title") as! String
            let baseDate = item.getBaseDate()
            
            print("TESTING UpdateActivityInCoreData found a matching entity: \(title)")
            print("TESTING updating lastUpdatedDate to \(baseDate)")
            print("TESTING updating streakCount to \(item.getStreakCount())")
            
            fetchedResults[0].setValue(baseDate, forKey: "baseDate")
            fetchedResults[0].setValue(item.getStreakCount(), forKey: "streakCount")
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save \(error)")
        }
        
    }
    
    
}