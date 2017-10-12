//
//  AddNewItemVC.swift
//  EasyMenu
//
//  Created by Nikze on 11/10/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import FirebaseAuth

class AddNewItemVC: Base {

    // MARK: - Property -
    struct ItemDetails {
        var itemDetail:NSDictionary = [:]
    }
    var items = [ItemDetails]()
    
    var itemName:[String] = []
    var itemDict = [NSDictionary]()
    var itemCategory:[String] = []
    var dict:[String:Array<String>] = [:]
    var ref:DatabaseReference?
    var handle:DatabaseHandle?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let orderId = UserDefaults.standard.string(forKey: "orderId")
    
    // MARK: - Outlet -
    @IBOutlet weak var txtItemCategory: UITextField!
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtItemQuantity: UITextField!
    @IBOutlet weak var txtItemPrice: UITextField!
    
    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Button Action -
    @IBAction func btnSave(_ sender: UIButton) {
        navigationController?.isNavigationBarHidden = false
        if UserDefaults.standard.string(forKey: "userId") != nil {
            
            let userPath = appDelegate.databaseRef.child(FTB_MyUsers).child((Auth.auth().currentUser!.uid))
            userPath.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary {
                    
                    if let orders = value["orders"] as? NSDictionary {
                        
                        for i in 0..<orders.allKeys.count {
                            
                            userPath.child("orders").child(orders.allKeys[i] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                if let value = snapshot.value as? NSDictionary {
                                    
                                    if let items = value["items"] as? NSDictionary {
                                        
                                        for j in 0..<items.allKeys.count {
                                            
                                            userPath.child("orders").child(orders.allKeys[i] as! String).child("items").child(items.allKeys[j] as! String).observeSingleEvent(of: .value, with: {(snapshot) in
                                                    if let value = snapshot.value as? NSDictionary {
                                                    
                                                    //                                                    if !self.itemCategory.contains(String(describing: items.allKeys[j])) {
                                                    //                                                        self.itemCategory.append(String(describing: items.allKeys[j]))
                                                    //                                                    }
                                                    
                                                    for k in 0..<value.allKeys.count {
                                                        self.itemName.append(String(describing: value.allKeys[k]))
                                                    }
                                                    print("itemName is \(self.itemName)")
                                                    self.dict = [items.allKeys[j] as! String : self.itemName]
                                                    
                                                        for l in 0..<self.itemName.count {
                                                        if self.itemName[l] == self.txtItemName.text {
                                                            self.DAlert(self.ALERT_TITLE, message: "Sorry! this \(self.itemName) already exists", action: self.ALERT_OK, sender: self)

                                                        } else {
                                                            self.addItem()
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            })
            { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func addItem() {
        if (txtItemCategory.text?.isEmpty)! && (txtItemName.text?.isEmpty)! && (txtItemQuantity.text?.isEmpty)! && (txtItemPrice.text?.isEmpty)! {
            
            itemCategory = [txtItemCategory.text!]
            let itmDict = ["subCategory":txtItemName.text!, "Price":Int(txtItemPrice.text!)!, "Quantity":Int(txtItemQuantity.text!)!] as [String : Any]
            self.itemDict.removeAll()
            self.itemDict.append(itmDict as NSDictionary)
            for i in 0..<(self.itemCategory.count){
                
                for j in 0..<(self.itemDict.count) {
                    
                    //let orderId = UserDefaults.standard.string(forKey: "orderId")
                    let cate = self.itemDict[j]["subCategory"] as? String
                    let userItems =  appDelegate.databaseRef.child(FTB_MyUsers).child((Auth.auth().currentUser?.uid)!).child("orders").child(orderId!).child("items").child(self.itemCategory[i]).child(cate!)
                    userItems.setValue(self.itemDict[j]){ (error, ref) in
                        
                        if error == nil{
                            
                        }
                    }
                }
            }
        } else {
            self.DAlert(self.ALERT_TITLE, message: "Enter all values", action: self.ALERT_OK, sender: self)
        }

    }
    
}
