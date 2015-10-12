//
//  ActivityItemCell.swift
//  Streaker
//
//  Created by Chris Larkin.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit

class ActivityItemCell : UITableViewCell {
    
    
    
    @IBAction func selectNoBtn(sender: UIButton) {
        let aData = ActivityData.sharedInstance
        let item = aData.activities[activityItemIndex]
        print("No btn selected on item \(item.getTitle())")
        item.reset(activityItemIndex)
    }
    
    @IBAction func selectYesBtn(sender: UIButton) {
        let aData = ActivityData.sharedInstance
        let item = aData.activities[activityItemIndex]
        print("Yes btn selected on item \(item.getTitle())")
        item.update(activityItemIndex)
    }
    
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var remindTimeLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var activityItemIndex : Int = 0
    
    func setIndex(index: Int) {
        print("Setting activityCells activityIndex to \(activityItemIndex)")
        activityItemIndex = index
    }
    
}