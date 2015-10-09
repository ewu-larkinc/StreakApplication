//
//  ActivityItemCell.swift
//  Streaker
//
//  Created by Chris Larkin on 10/5/15.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit

class ActivityItemCell : UITableViewCell {
    
    @IBAction func selectNoBtn(sender: UIButton) {
        let aData = ActivityData.sharedInstance
        let item = aData.activities[activityItemIndex]
        item.reset()
    }
    
    @IBAction func selectYesBtn(sender: UIButton) {
        
        let aData = ActivityData.sharedInstance
        let item = aData.activities[activityItemIndex]
        item.update()
    }
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var remindTimeLabel: UILabel!
    
    var activityItemIndex : Int = 0
    
    func setIndex(index: Int) {
        activityItemIndex = index
    }
    
}