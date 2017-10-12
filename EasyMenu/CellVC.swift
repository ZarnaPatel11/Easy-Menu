//
//  CellVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 29/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class CellVC: UITableViewCell {

// Mark: - CreateOrderVC
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblPersons: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    var order:String = ""
    
// Mark: - AddItemVC
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var lblItemQuantity: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
// Mark: - OrderDetailVC
    @IBOutlet weak var lblItemNm: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    
    var dataDict:[String:String] = [:]
    
    func displayInitialvalue() {
//        lblName.text = dataDict["item_name"].stringValue
//        lblCount.text = dataDict["item_Qty"].stringValue
        //lblItemName.text = String(describing: dataDict)
       
        
        
    }
}
