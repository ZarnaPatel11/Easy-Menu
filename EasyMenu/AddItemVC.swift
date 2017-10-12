//
//  AddItemVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 02/10/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import FirebaseAuth

class AddItemVC: Base, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    struct Objects {
        var itemCategory : String!
        var itemName : [String]!
    }
    var objectArray = [Objects]()
    
    var ref:DatabaseReference?
    var handle:DatabaseHandle?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Mark: - Property -
    var searchActive : Bool = false
    var itemName:[String] = []
    var itemCategory:[String] = []
    var dict:[String:Array<String>] = [:]
    var hotelDetails = [HotelDetails]()
    var itemDetails = [ItemDetails]()
    var seletedSection = Int()
    var seletedTitle = [String]()
    var seletedDescription = [NSDictionary]()
    var itemKey = [String]()
    var itemKeyArray:[String] = []
    var orderID = String()

    // Mark: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!

    // Mark: - View load Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationController?.isNavigationBarHidden = false
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
            
            let userPath = appDelegate.databaseRef.child(FTB_MyUsers).child((Auth.auth().currentUser!.uid)).child("orders")
            userPath.observeSingleEvent(of: .value, with: { (snapshot) in
             //print(snapshot.value!)
                if let value = snapshot.value as? NSDictionary {
                    //print(value.allKeys)
                    
                    let dict:Any = value.allKeys
                    
                  //  print(dict[0])
                    print(dict)
                    
                }
                
            })
            
        
        
            
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    @IBAction func btnAddNewItem(_ sender: UIButton) {
        let nxt = self.storyboard?.instantiateViewController(withIdentifier: STORYBOARD_IDENTIFIER_AddNewItemVC) as! AddNewItemVC
        self.navigationController?.pushViewController(nxt, animated: true)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        for i in 0..<(self.seletedTitle.count){
            for j in 0..<(self.seletedDescription.count) {
                
                let cate = self.seletedDescription[j]["subCategory"] as? String
                print("orderId is \(orderID)")
                let userItems =  appDelegate.databaseRef.child(FTB_MyUsers).child((Auth.auth().currentUser?.uid)!).child("orders").child(orderID).child("items").child(self.seletedTitle[i]).child(cate!)
                userItems.setValue(self.seletedDescription[j]){ (error, ref) in
                    if error == nil{
                        
                    }
                }
            }
        }
    }
  
    // Mark: - TableView Methods -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return objectArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objectArray[section].itemName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellVC
        
            cell.lblItemName.text = self.objectArray[indexPath.section].itemName[indexPath.row]
            self.seletedSection = indexPath.section
            cell.stepper.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: .valueChanged)
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].itemCategory
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 20)
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func NewValues(_ step:UIStepper){
        print("step :- \(step)")
    }
    //MARK: -  SearchBar Delegate  -
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchActive = true;
       searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false;
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
     // here your search code set
    }
    func stepperValueChanged(_ sender:UIStepper!){
        DispatchQueue.main.async {
            
        
        print("UIStepper is now \(Int(sender.value))")
        if let cell = sender.superview?.superview as? CellVC {
            let indexPath = self.tblView.indexPath(for: cell)
            cell.lblItemQuantity.text = String(sender.value)
            let quantity = cell.lblItemQuantity.text
            
            print("indexPath is \(String(describing: indexPath))")
            print("sender value is \(sender.value)")
            print("Qty label is \(String(describing: quantity))")
            self.seletedTitle.append(self.objectArray[(indexPath?.section)!].itemCategory)
            print("Title is now \(self.seletedTitle)")
            if cell.txtPrice.text != ""{
                let dict:NSDictionary = ["subCategory":cell.lblItemName.text!,"Price":Int(cell.txtPrice.text!)!,"Quantity":2]
                self.seletedDescription.append(dict)
                print("SeletedDescription is now \(self.seletedDescription)")
            }
            else{
                self.DAlert(self.ALERT_TITLE, message: "Seltect Price", action: self.ALERT_OK, sender: self)
            }
     
            }
        }
    }
}




//func stepperValueChanged(_:UIStepper) {
//    let row:Int = (stepper.superview?.tag)!
//    let value:Int = Int(stepper.value)
//    print("Row : \(row) Value: \(value)")
//
//}

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
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true;
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false;
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false;
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = true;
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text as NSString
//            //let range = tmp.rangeOfString(searchText, options: NSString.CompareOptions.CaseInsensitiveSearch)
//            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//            
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tblView.reloadData()
//    }




