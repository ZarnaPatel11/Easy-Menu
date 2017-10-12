//
//  PastOrderDetailVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 29/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class OrderDetailVC: Base, UITableViewDataSource, UITableViewDelegate {

    // Mark: - Property -
    struct Dict {
        var price: String!
        var quantity: String!
        var subCategory: String!
    }
    var finalDict = [Dict]()
    
    var billAmount:Int = 0
    var ref:DatabaseReference?
    var handle:DatabaseHandle?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var orderId:String = ""
    
    // Mark: - Outlets -
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        print("orderID in OrderDetailVC is \(orderId)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        if UserDefaults.standard.string(forKey: "userId") != nil {
            
            let userPath = appDelegate.databaseRef.child(FTB_MyUsers).child((Auth.auth().currentUser!.uid))
            userPath.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary {
                    
                    if (value["orders"] as? NSDictionary) != nil {
                        userPath.child("orders").child(self.orderId).observeSingleEvent(of: .value, with: { (snapshot) in
                            //print("snapshot.value is \(String(describing: snapshot.value))")
                            if (snapshot.value as? NSDictionary) != nil {
                                let item:NSDictionary = (snapshot.value as! NSDictionary).value(forKey: "items") as! NSDictionary
                                let itemCategory:[String] = (item.allKeys as? [String])!
                                for index in 0..<itemCategory.count {
                                    let subCategory = item.value(forKey: itemCategory[index]) as! NSDictionary
                                    let singleSubCategory:[String] = subCategory.allKeys as! [String]
                                    for i in 0..<singleSubCategory.count {
                                        let newitems:NSDictionary = subCategory.value(forKey: singleSubCategory[i]) as! NSDictionary
                                        let price = newitems.value(forKey: "Price") as! Int
                                        let quantity = newitems.value(forKey: "Quantity")  as! Int
                                        let subCategory = newitems.value(forKey: "subCategory") as! String
                                        self.billAmount = self.billAmount + ((price) * (quantity))
                                        self.lblTotalAmount.text = String(self.billAmount)
                                        self.finalDict.append(Dict(price: String(price) , quantity: String(quantity), subCategory:subCategory))
                                        DispatchQueue.main.async {
                                            self.tblView.reloadData()
                                        }
                                        
                                    }
                                    
                                }
                            } 
                            
                        })
                        
                    }
                }
            })
            { (error) in
                print(error.localizedDescription)
            }
            
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    // Mark: - TableView Methods -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalDict.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellVC
        cell.lblItemNm.text = self.finalDict[indexPath.row].subCategory
        cell.lblItemQty.text = self.finalDict[indexPath.row].quantity
        cell.lblItemPrice.text = self.finalDict[indexPath.row].price
        return cell
    }
    
}
