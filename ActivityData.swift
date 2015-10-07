//
//  ActivityData.swift
//  Streaker
//
//  Created by Chris Larkin on 10/5/15.
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
    var selectedActivity: ActivityItem?
    let entityKeyType = "EntityActivity"
    let entityKeyTitle = "title"
    let entityKeyDescription = "descript"
    let entityBaseCount = "streakCount"
    let entityBaseDate = "baseDate"
    
    init() {
        activities = [ActivityItem]()
    }
    
    func addActivity(newItem: ActivityItem) {
        activities.append(newItem)
        saveActivity(newItem)
    }
    
    
    //#MARK: - Core Data Methods
    func saveActivity(item: ActivityItem) {
        
        print("Testing... adding item \(item.getTitle()) to core data")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entityDescription = NSEntityDescription.entityForName(entityKeyType, inManagedObjectContext: managedContext)
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
    
    func fetchFromCoreData() -> [NSManagedObject] {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: entityKeyType)
        
        let fetchedResults = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        return fetchedResults
    }
    
    func readInFromCoreData() {
        
        let cdItems = fetchFromCoreData()
        print("Core data count (fetched) is \(cdItems.count)")
        
        for item in cdItems {
            
            let title = item.valueForKey(entityKeyTitle) as! String
            let description = item.valueForKey(entityKeyDescription) as! String
            let lastUpdatedDate = item.valueForKey(entityBaseDate) as! NSDate
            let baseCount = item.valueForKey(entityBaseCount) as! Int
            
            let newActivity = ActivityItem(title: title, description: description, baseDate: lastUpdatedDate, streakCount: baseCount)
            
            activities.append(newActivity)
        }
        
    }
    
    func updateActivityInCoreData(item: ActivityItem) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: entityKeyType)
        let predicate = NSPredicate(format: "title == %@", item.getTitle())
        fetchRequest.predicate = predicate
        
        
        let fetchedResults = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        if fetchedResults.count > 0 {
            
            let title = fetchedResults[0].valueForKey("title") as! String
            let baseDate = item.getBaseDate()
            
            
            print("UpdateActivityInCoreData found a matching entity: \(title)")
            print("updating lastUpdatedDate to \(baseDate)")
            print("updating streakCount to \(item.getStreakCount())")
            
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