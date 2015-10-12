//
//  AddActivityViewController.swift
//  Streaker
//
//  Created by Chris Larkin.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit

class AddActivityViewController : UIViewController, UITextFieldDelegate {
    
    //#MARK: - IBAction Functions
    @IBAction func cancelBtnSelected(sender: UIButton) {
        hideFormItems()
    }
    
    @IBAction func submitBtnSelected(sender: UIButton) {
        
        let aData = ActivityData.sharedInstance
        guard let titleText = titleTextfield.text, descriptionText = descriptTextfield.text, preferredTime = aData.getCurrentlySelectedTime() else {
            
            let alertBox = UIAlertController(title: "Incomplete Form", message: "The form has not been completed. Please provide a title, description, and preferred time.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertBox.addAction(alertAction)
            
            self.presentViewController(alertBox, animated: true, completion: nil)
            return
        }
        
        let newActivity = ActivityItem(title: titleText, description: descriptionText, preferredTime: preferredTime)
        aData.addActivity(newActivity)
        hideFormItems()
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: self)
    }
    
    @IBAction func AddActivitySelected(sender: UIButton) {
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
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        descriptTextfield.delegate = self
        titleTextfield.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        animateAddButton()
        
        let aData = ActivityData.sharedInstance
        
        guard let selectedTime = aData.getCurrentlySelectedTime() else {
            return
        }
        
        print("TESTING currently selected time detected - changing button text now...")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh"
        let hour = dateFormatter.stringFromDate(selectedTime)
        dateFormatter.dateFormat = "mm a"
        let minutes = dateFormatter.stringFromDate(selectedTime)
        
        let timeString = hour + ":" + minutes
        
        reminderSelectButton.setTitle(timeString, forState: UIControlState.Normal)
    }
    
    func hideFormItems() {
        descriptLabel.hidden = true
        descriptLabel.enabled = false
        titleLabel.hidden = true
        titleLabel.enabled = false
        reminderTimeLabel.hidden = true
        reminderTimeLabel.enabled = false
        descriptTextfield.hidden = true
        descriptTextfield.enabled = false
        reminderSelectButton.hidden = true
        reminderSelectButton.enabled = false
        titleTextfield.hidden = true
        titleTextfield.enabled = false
        submitBtn.enabled = false
        submitBtn.hidden = true
        cancelBtn.hidden = true
        cancelBtn.enabled = false
        
        showAddBtn()
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
        cancelBtn.enabled = true
        cancelBtn.hidden = false
        
        hideAddBtn()
    }
    
    //#MARK - Misc.
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
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: [.Autoreverse, .Repeat, .AllowUserInteraction], animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 2/3, animations: {
                self.addActivityBtn.transform = CGAffineTransformMakeScale(1.15, 1.15)
            })
            
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                self.addActivityBtn.transform = CGAffineTransformMakeScale(1.25, 1.25)
            })
            
        }, completion: nil)
    }
    
    //#MARK: - UITextField Delegate Functions
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
