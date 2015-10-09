//
//  AddActivityViewController.swift
//  Streaker
//
//  Created by Chris Larkin.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit

class AddActivityViewController : UIViewController {
    
    
    
    
    @IBAction func submitBtnSelected(sender: UIButton) {
        
        if let titleText = titleTextfield.text {
            
            if let descriptionText = descriptTextfield.text {
                print("TESTING Adding new item titled \(titleText)")
                let aData = ActivityData.sharedInstance
                
                if let preferredTime = aData.getCurrentlySelectedTime() {
                    
                    let newActivity = ActivityItem(title: titleText, description: descriptionText, preferredTime: preferredTime)
                    aData.addActivity(newActivity)
                    hideFormItems()
                    showAddBtn()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: self)
                }
                
                
            }
        }
        
    }
    
    @IBAction func AddActivitySelected(sender: UIButton) {
        hideAddBtn()
        showFormItems()
    }
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var descriptTextfield: UITextField!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var addActivityBtn: UIButton!
    @IBOutlet weak var reminderSelectButton: UIButton!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        
        animateAddButton()
        
        let aData = ActivityData.sharedInstance
        if let selectedTime = aData.getCurrentlySelectedTime() {
            
            print("TESTING currently selected time detected - changing button text now...")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh"
            let hour = dateFormatter.stringFromDate(selectedTime)
            dateFormatter.dateFormat = "mm a"
            let minutes = dateFormatter.stringFromDate(selectedTime)
            
            let timeString = hour + ":" + minutes
            
            reminderSelectButton.setTitle(timeString, forState: UIControlState.Normal)
        }
    }
    
    func hideFormItems() {
        descriptLabel.hidden = true
        titleLabel.hidden = true
        descriptTextfield.hidden = true
        descriptTextfield.enabled = false
        reminderSelectButton.hidden = true
        reminderSelectButton.enabled = false
        reminderTimeLabel.hidden = true
        reminderTimeLabel.enabled = false
        titleTextfield.hidden = true
        titleTextfield.enabled = false
        submitBtn.enabled = false
        submitBtn.hidden = true
    }
    
    func showFormItems() {
        descriptLabel.hidden = false
        titleLabel.hidden = false
        descriptTextfield.hidden = false
        descriptTextfield.enabled = true
        reminderSelectButton.hidden = false
        reminderSelectButton.enabled = true
        reminderTimeLabel.hidden = false
        reminderTimeLabel.enabled = true
        titleTextfield.hidden = false
        titleTextfield.enabled = true
        submitBtn.enabled = true
        submitBtn.hidden = false
    }
    
    func hideAddBtn() {
        addActivityBtn.hidden = true
        addActivityBtn.enabled = false
    }
    
    func showAddBtn() {
        addActivityBtn.hidden = false
        addActivityBtn.enabled = true
    }
    
    
    
    func animateAddButton() {
        
        let duration = 1.0
        let delay = 0.0
        //[.Autoreverse, .Repeat]
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: [.Autoreverse, .Repeat, .AllowUserInteraction], animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 2/3, animations: {
                self.addActivityBtn.transform = CGAffineTransformMakeScale(1.15, 1.15)
            })
            
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                self.addActivityBtn.transform = CGAffineTransformMakeScale(1.25, 1.25)
            })
            
            }, completion: nil)
    }
    
    
}
