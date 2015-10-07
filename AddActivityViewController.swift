//
//  AddActivityViewController.swift
//  Streaker
//
//  Created by Chris Larkin on 10/5/15.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit

class AddActivityViewController : UIViewController {
    
    @IBAction func submitBtnSelected(sender: UIButton) {
        
        if let titleText = titleTextfield.text {
            
            if let descriptionText = descriptTextfield.text {
                print("Adding new item titled \(titleText)")
                let aData = ActivityData.sharedInstance
                let newActivity = ActivityItem(title: titleText, description: descriptionText)
                aData.addActivity(newActivity)
                hideFormItems()
                showAddBtn()
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
    
    
    func hideFormItems() {
        descriptLabel.hidden = true
        titleLabel.hidden = true
        descriptTextfield.hidden = true
        descriptTextfield.enabled = false
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
}
