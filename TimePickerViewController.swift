//
//  TimePickerViewController.swift
//  Streaker
//
//  Created by Chris Larkin on 10/7/15.
//  Copyright © 2015 CLProductions. All rights reserved.
//

import Foundation
import UIKit

class TimePickerViewController : UIViewController {
    
    @IBAction func cancelButtonSelected(sender: UIButton) {
        datePicker.reloadInputViews()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirmButtonSelected(sender: UIButton) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh/mm"
        
        let aData = ActivityData.sharedInstance
        aData.setCurrentlySelectedTime(datePicker.date)
        datePicker.reloadInputViews()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var navBarView: UIView!
    
    override func viewDidLoad() {
        navBarView.layer.shadowOpacity = 0.7
        navBarView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        navBarView.layer.shadowRadius = 1.0
    }
    
}