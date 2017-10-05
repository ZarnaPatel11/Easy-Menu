//
//  CellVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 29/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit

class CellVC: UITableViewCell {

    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblPersons: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var dataDict = [String]()

    func displayInitialvalue() {
       
        //lblItemQty.text = dataDict["item_Qty"]
    }
    
    
}
