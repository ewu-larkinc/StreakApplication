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
    
    @IBAction func confirmButtonSelected(sender: UIButton) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh/mm"
        
        let aData = ActivityData.sharedInstance
        aData.setCurrentlySelectedTime(datePicker.date)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func datePickerChanged(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    
}