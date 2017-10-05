//
//  AddItemVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 02/10/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var ref:DatabaseReference?
    var handle:DatabaseHandle?

    // Mark: - Variable Declaration
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
//    var items = [
//        Item(items: "Soup", itemName: ["Tomato Soup","Manchow Soup","Hot & Sour Soup","Corn & Cheese Soup","Coconut & Vegetable Soup"]),
//        Item(items: "Salad", itemName: ["Vegetable Salad","Fruit Salad","Green Salad","Diet Salad","Boiled Salad"]),
//        Item(items: "Starter", itemName: ["Paneer Chilly","Manchurian Dry","Veg Kabab","Paneer Kabab","Noodles"]),
//        Item(items: "Curries", itemName: ["Paneer Tikka","Paneer Toofani","Paneer Afghani","Cheese Butter Masala","Mix Vegetables"]),
//        Item(items: "Roti", itemName: ["Chapati","Butter Chapati","Tandoori Roti","Butter Naan","Cheese Naan"]),
//        Item(items: "Rice And Dal", itemName: ["Jeera Rice","Hyderabadi Biryanni","Veg Pulav","Dal Fry","Dal Tadka"]),
//        Item(items: "Beverages", itemName: ["Butter Milk","Soft Drinks","Mojitos","Mocktails"])
//    ]
    
    var hotelDetails = [HotelDetails]()
    var itemDetails = [ItemDetails]()
    // Mark: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!

    // Mark: - View load Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if let email = UserDefaults.standard.string(forKey: "userId") {
            ref = Database.database().reference()
            ref?.child("MyUsers/\(email)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary {
                    
                    if let orders = value["orders"] as? NSDictionary {
                        
                        for i in 0..<orders.allKeys.count {
                            
                            self.ref?.child("MyUsers/\(email)/orders/\(orders.allKeys[i])").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                if let value = snapshot.value as? NSDictionary {
                                    
                                   // print("addItemVC \(value)")
                                    
                                    if let items = value["items"] as? NSDictionary {
                                        for j in 0..<items.allKeys.count {
                                            self.ref?.child("MyUsers/\(email)/orders/\(orders.allKeys[i])/items/\(items.allKeys[j])").observeSingleEvent(of: .value, with: {(snapshot) in
                                                if let value = snapshot.value as? NSDictionary {
                                                    
//                                                    let itemCategory = value["item_category"] as? String
//                                                    let itemName = value["item_name"] as? String
//                                                    let itemQuantity = value["item_quantity"] as? String
//                                                    self.itemDetails.insert(ItemDetails(item_category: itemCategory, item_name: itemName, item_quantity: itemQuantity), at: 0)
                                                    print("value in last inner is \(value)")
                                                    self.tblView.reloadData()
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
    
    // Mark: - TableView Methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(searchActive) {
//            return filtered.count
//        }
        return itemDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellVC
        cell.lblItemName.text = itemDetails[indexPath.row].item_name
//        cell.lblPersons.text = hotelDetails[indexPath.row].persons
//        cell.lblDate.text = hotelDetails[indexPath.row].date
        return cell
    }

    
    /*func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].items
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 25)
        header.contentView.backgroundColor = UIColor.lightGray
    }*/
    
    
//    func Stepper(_ sender: UIStepper) {
//        if let cell = sender.superview?.superview as? CellVC {
//            let indexPath = tblView.indexPath(for: cell)
//            let quantity = cell.lblItemQty.text
//            
//            print("indexPath is \(String(describing: indexPath))")
//            print("sender valu is \(sender.value)")
//            print("Qty label is \(quantity)")
//            
//            cell.lblItemQty.text = String(sender.value)
//            tblView.reloadRows(at: [indexPath!], with: .automatic)
//        }
//    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let index = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
//        let currentCell = tableView.cellForRow(at: index!)!
//        print(currentCell.textLabel!.text!)
//        let itemName = currentCell.textLabel?.text
//
//        let sectionHeaderView = tblView.headerView(forSection: indexPath.section)
//        let sectionTitle = sectionHeaderView?.textLabel?.text
//        print(sectionTitle!)
//        
//        let orderId = UserDefaults.standard.string(forKey: "orderId")
//        print("orderId in addVC is \(orderId!)")
//        let userId = UserDefaults.standard.string(forKey: "userId")
//        print("userId in addVc is \(userId!)")
//        
//        self.ref = Database.database().reference()
//        self.ref?.child("MyUsers/\(userId!)/orders/\(orderId!)").child("\(sectionTitle!)").child("\(itemName!)").setValue("5")
//
//    }
    
    // Mark: - SearchBar Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            //let range = tmp.rangeOfString(searchText, options: NSString.CompareOptions.CaseInsensitiveSearch)
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tblView.reloadData()
    }

}
