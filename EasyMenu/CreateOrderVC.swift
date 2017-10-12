//
//  CreateOrderVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 02/10/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateOrderVC: Base {

    // MARK: - Outlet -
    
    @IBOutlet weak var txtHotelName: UITextField!
    @IBOutlet weak var txtPersons: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    // MARK: - Property -
    
    var userId = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        let result = formatter.string(from: date)
        txtDate.text = result
        userId = UserDefaults.standard.string(forKey: "userId")!
    }

    // MARK: - Button Action -
    
    @IBAction func btnCreateOrder(_ sender: UIButton) {
        
        let hotelName = self.txtHotelName.text
        let date = self.txtDate.text
        
        let dateStr = convertGivenDateToString(Date(), dateformat: "dd-MMM-yyyy hh:mm:ss")
        let array = dateStr.components(separatedBy: " ");
        let datestr = array[0]//.replacingOccurrences(of: "-", with: " ")
        let timestr = array[1].replacingOccurrences(of: ":", with: "-")
        let orderId:String = hotelName! + "-" + datestr + timestr

        let createOrderDict : NSDictionary = ["hotel_name":self.txtHotelName.text!,"persons":self.txtPersons.text!,"date":date!]
        let createOrder = appDelegate.databaseRef.child(FTB_MyUsers).child((Auth.auth().currentUser?.uid)!).child("orders")
        createOrder.child(orderId).setValue(createOrderDict){ (error, ref) in
            
            if error == nil{
        
                UserDefaults.standard.set(orderId, forKey: "orderId")
                
                let AddItemVC = self.storyboard?.instantiateViewController(withIdentifier: self.STORYBOARD_IDENTIFIER_AddItemVC) as! AddItemVC
                AddItemVC.orderID = orderId
                self.navigationController?.pushViewController(AddItemVC, animated: true)
            }
        }
    }
    
    func convertGivenDateToString(_ date : Date ,dateformat : String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformat // superset of OP's format
        let str = dateFormatter.string(from: date)
        return str
    }
    
    //MARK: - Delegate MEethod -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
