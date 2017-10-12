//
//  HomeVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 29/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeVC:Base, UITableViewDelegate, UITableViewDataSource {
    
   // Mark: - Property -
    struct Order {
        var orderId:String!
    }
    var order = Order()
    var hotelDetails = [HotelDetails]()
    var secDate:[String] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    // Mark: - Outlets -
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        self.hotelDetails.removeAll()
        if UserDefaults.standard.string(forKey: "userId") != nil {
            let userInfo = appDelegate.databaseRef.child(FTB_MyUsers).child((Auth.auth().currentUser?.uid)!)
            userInfo.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary {
                    if let orders = value["orders"] as? NSDictionary {
                        for i in 0..<orders.allKeys.count {
                            self.appDelegate.databaseRef.child("MyUsers/\((Auth.auth().currentUser?.uid)!)/orders/\(orders.allKeys[i])").observeSingleEvent(of: .value, with: { (snapshot) in
                               
                                if let value = snapshot.value as? NSDictionary {
                                    
                                    let hotelName = value["hotel_name"] as? String
                                    let persons = value["persons"] as? String
                                    let sectionDate = value["date"] as? String
                                    let orderId = orders.allKeys[i] as? String
                                    //print(sectionDate!)
                                    
                                    self.hotelDetails.insert(HotelDetails(hotel_name: hotelName, persons: persons, date: sectionDate, orderId: orderId),at: 0)
                                    //print(self.hotelDetails)
                                    
                                    let dateAsString = sectionDate
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd-MM-yyyy"
                                    if let date = dateFormatter.date(from: dateAsString!) {
                                        dateFormatter.dateFormat = "MMM-yyyy"
                                        
                                        if !self.secDate.contains(dateFormatter.string(from: date)) {
                                            self.secDate.append("\(dateFormatter.string(from: date))")
                                        }
                                        
                                        print(self.secDate)
                                        print("date is \(dateFormatter.string(from: date))")

                                        
                                        
                                        
                                    }
                                   // DispatchQueue.main.async {
                                        self.tblView.reloadData()
                                    
                                   // }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Mark: - Button Action -
    
    @IBAction func btnLogout(_ sender: UIBarButtonItem) {
        
        UserDefaults.standard.set(false, forKey: "loggedIn")
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // Mark: - TableView Methods -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelDetails.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return secDate.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellVC
       
            cell.lblHotelName.text = hotelDetails[indexPath.row].hotel_name
            cell.lblPersons.text = hotelDetails[indexPath.row].persons
            cell.lblDate.text = hotelDetails[indexPath.row].date
            cell.order = hotelDetails[indexPath.row].orderId
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nxt = storyboard?.instantiateViewController(withIdentifier: self.STORYBOARD_IDENTIFIER_OrderDetailVC) as! OrderDetailVC
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! CellVC
        nxt.title = "\(currentCell.lblHotelName.text!) \(currentCell.lblPersons.text!) \(currentCell.lblDate.text!)"
        nxt.orderId = currentCell.order
        self.navigationController?.pushViewController(nxt, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return secDate[section]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 44
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 20)
        header.contentView.backgroundColor = UIColor.lightGray
    }
}
