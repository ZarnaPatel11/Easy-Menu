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

class CreateOrderVC: UIViewController {

    var userId = ""
    var ref:DatabaseReference?
    var handle:DatabaseHandle?
    
    @IBOutlet weak var txtHotelName: UITextField!
    @IBOutlet weak var txtPersons: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
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

    @IBAction func btnCreateOrder(_ sender: UIButton) {
        ref = Database.database().reference()
        let hotelName = txtHotelName.text
        let persons = txtPersons.text
        let date = txtDate.text
        
        let dateStr = convertGivenDateToString(Date(), dateformat: "MMM-dd-yyyy hh:mm:ss")
        let array = dateStr.components(separatedBy: " ");
        let datestr = array[0]//.replacingOccurrences(of: "-", with: "-")
        let timestr = array[1].replacingOccurrences(of: ":", with: "-")
        let orderId:String = hotelName! + "_" + datestr + "_" + timestr
        
        let users = ["hotel_name":hotelName,"persons":persons,"date":date]
        ref?.child("MyUsers/\(userId)/orders").child(orderId).setValue(users)

        UserDefaults.standard.set(orderId, forKey: "orderId")
        let nxt = self.storyboard?.instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        self.navigationController?.pushViewController(nxt, animated: true)
    }
    
    func convertGivenDateToString(_ date : Date ,dateformat : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformat // superset of OP's format
        let str = dateFormatter.string(from: date)
        return str
    }

}
