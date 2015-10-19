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
    @IBOutlet weak var titleImageView: UIImageView!
    
    @IBOutlet weak var formBackgroundView: UIView!
    
    
    
    //#MARK: - IBAction Functions
    @IBAction func cancelBtnSelected(sender: UIButton) {
        hideFormItems()
        clearEntries()
    }
    
    @IBAction func submitBtnSelected(sender: UIButton) {
        
        let aData = ActivityData.sharedInstance
        
        //no longer using guard below, because textfields dont return nil when empty, so I have to make an explicit count check on the title and description fields before creating a new activity item.
        if let titleText = titleTextfield.text?.capitalizedString, descriptionText = descriptTextfield.text?.capitalizedString, preferredTime = aData.getCurrentlySelectedTime() {
            
            if titleText.characters.count == 0 && descriptionText.characters.count == 0 {
                let alertBox = UIAlertController(title: "Incomplete Form", message: "The form has not been completed. Please provide a title, description, and preferred time.", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertBox.addAction(alertAction)
            
                self.presentViewController(alertBox, animated: true, completion: nil)
                return
                
            } else {
                //print("Testing... new title is \(titleText) and description is \(descriptionText)")
                let newActivity = ActivityItem(title: titleText, description: descriptionText, preferredTime: preferredTime)
                aData.addActivity(newActivity)
                hideFormItems()
                clearEntries()
            }
        }
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableViewData", object: self)
    }
    
    @IBAction func AddActivitySelected(sender: UIButton) {
        showFormItems()
    }
    
    
    @IBOutlet weak var descriptTextfield: UITextField!
    @IBOutlet weak var titleTextfield: UITextField!
    /*@IBOutlet weak var reminderTimeLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!*/
    @IBOutlet weak var addActivityBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var reminderSelectButton: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var addActivityLabel: UILabel!
    @IBOutlet weak var addActivityButtonView: UIView!
    @IBOutlet weak var addActivityImage: UIImageView!
    @IBOutlet weak var preferredTimeTextfield: UITextField!
    
    private var formColor = UIColor()
    
    override func viewDidLoad() {
        descriptTextfield.delegate = self
        titleTextfield.delegate = self
        formColor = addActivityLabel.textColor
        
        //self.tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        tabBarController?.tabBar.barTintColor = UIColor.whiteColor()
        
        //set drop shadow and corner radius on add activity button view, and all buttons.
        titleImageView.layer.shadowOpacity = 0.7
        titleImageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleImageView.layer.shadowRadius = 1
        
        addActivityButtonView.layer.shadowOpacity = 0.7
        addActivityButtonView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        addActivityButtonView.layer.shadowRadius = 1
        addActivityButtonView.layer.cornerRadius = 3
        
        /*reminderSelectButton.layer.shadowOpacity = 0.7
        reminderSelectButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        reminderSelectButton.layer.shadowRadius = 1*/
        reminderSelectButton.layer.cornerRadius = 5
        
        /*submitBtn.layer.shadowOpacity = 0.7
        submitBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        submitBtn.layer.shadowRadius = 1*/
        submitBtn.layer.cornerRadius = 5
        
        /*cancelBtn.layer.shadowOpacity = 0.7
        cancelBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cancelBtn.layer.shadowRadius = 1*/
        cancelBtn.layer.cornerRadius = 5
        
        formBackgroundView.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        animateAddButton()
        
        let aData = ActivityData.sharedInstance
        
        guard let selectedTime = aData.getCurrentlySelectedTime() else {
            return
        }
        
        //print("TESTING currently selected time detected - changing button text now...")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh"
        let hour = dateFormatter.stringFromDate(selectedTime)
        dateFormatter.dateFormat = "mm a"
        let minutes = dateFormatter.stringFromDate(selectedTime)
        
        let timeString = hour + ":" + minutes
        
        preferredTimeTextfield.text = timeString
        //reminderSelectButton.setTitle(timeString, forState: UIControlState.Normal)
    }
    
    //#MARK: - Misc. Functions
    func hideFormItems() {
        /*descriptLabel.hidden = true
        descriptLabel.enabled = false
        titleLabel.hidden = true
        titleLabel.enabled = false
        reminderTimeLabel.hidden = true
        reminderTimeLabel.enabled = false*/
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
        addActivityButtonView.hidden = false
        addActivityBtn.hidden = false
        addActivityBtn.enabled = true
        preferredTimeTextfield.hidden = true
        preferredTimeTextfield.enabled = false
        formBackgroundView.backgroundColor = UIColor.whiteColor()
        
        formBackgroundView.layer.shadowOpacity = 0
        formBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        formBackgroundView.layer.shadowRadius = 0
        //addActivityLabel.hidden = true
        //addActivityLabel.enabled = false
        
        showAddBtn()
    }
    
    func showFormItems() {
        /*descriptLabel.hidden = false
        titleLabel.hidden = false*/
        descriptTextfield.hidden = false
        descriptTextfield.enabled = true
        reminderSelectButton.hidden = false
        reminderSelectButton.enabled = true
        /*reminderTimeLabel.hidden = false
        reminderTimeLabel.enabled = true*/
        titleTextfield.hidden = false
        titleTextfield.enabled = true
        submitBtn.enabled = true
        submitBtn.hidden = false
        cancelBtn.enabled = true
        cancelBtn.hidden = false
        addActivityButtonView.hidden = true
        addActivityBtn.hidden = true
        addActivityBtn.enabled = false
        preferredTimeTextfield.hidden = false
        preferredTimeTextfield.enabled = true
        formBackgroundView.backgroundColor = formColor
        
        formBackgroundView.layer.shadowOpacity = 0.7
        formBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        formBackgroundView.layer.shadowRadius = 1
        //addActivityLabel.hidden = false
        //addActivityLabel.enabled = true
        
        hideAddBtn()
    }
    
    func clearEntries() {
        titleTextfield.text = nil
        descriptTextfield.text = nil
        preferredTimeTextfield.text = nil
        let aData = ActivityData.sharedInstance
        aData.resetCurrentlySelectedTime()
        reminderSelectButton.setTitle("Select Time", forState: UIControlState.Normal)
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
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: [.Autoreverse, .Repeat, .AllowUserInteraction], animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 2/3, animations: {
                self.addActivityBtn.transform = CGAffineTransformMakeScale(1.15, 1.15)
            })
            
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                self.addActivityBtn.transform = CGAffineTransformMakeScale(1.25, 1.25)
            })
            
        }, completion: nil)
    }
    
    //#MARK: - UITextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
