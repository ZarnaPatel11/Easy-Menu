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

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   // Mark: - Variable declaration
    var sections = [
        Section(orders: "Sept 2017", orderDetail: [["hotel":"Tomato","persons":"4","date":" 15 Sept"],
                                                   ["hotel":"Patang","persons":" 5","date":"5 Sept"],
                                                   ["hotel":"Radisson","persons":"2","date":"1 Sept"]]),
        Section(orders: "Aug 2017", orderDetail: [["hotel":"Madhubhan","persons":"3","date":"21 Aug"],
                                                  ["hotel":"TGB","persons":"4","date":"18 Aug"],
                                                  ["hotel":"Sahyog","persons":"6","date":"5 Aug"]]),
        Section(orders: "July 2017", orderDetail: [["hotel":"Tomato","persons":"7","date":"28 July"],
                                                   ["hotel":"Nakshatra","persons":"2","date":"20 July"],
                                                   ["hotel":"Premvati","persons":"3","date":"15 July"]])
    ]
    
    var ref:DatabaseReference?
    var hotelDetails = [HotelDetails]()
    
    // Mark: - Outlets
    @IBOutlet weak var tblView: UITableView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Mark: - View Load Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        hotelDetails.removeAll()
        if let email = UserDefaults.standard.string(forKey: "userId") {
            ref = Database.database().reference()
            ref?.child("MyUsers/\(email)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    if let orders = value["orders"] as? NSDictionary {
                        for i in 0..<orders.allKeys.count {
                            self.ref?.child("MyUsers/\(email)/orders/\(orders.allKeys[i])").observeSingleEvent(of: .value, with: { (snapshot) in
                                if let value = snapshot.value as? NSDictionary {
                                    //print(value)
                                    let hotelName = value["hotel_name"] as? String
                                    let persons = value["persons"] as? String
                                    let date = value["date"] as? String
                                    self.hotelDetails.insert(HotelDetails(hotel_name: hotelName, persons: persons, date: date),at: 0)
                                    self.tblView.reloadData()
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
    
    // Mark: - Button action for logout
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
    
    // Mark: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellVC
        cell.lblHotelName.text = hotelDetails[indexPath.row].hotel_name
        cell.lblPersons.text = hotelDetails[indexPath.row].persons
        cell.lblDate.text = hotelDetails[indexPath.row].date
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nxt = storyboard?.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! CellVC
        nxt.title = "\(currentCell.lblHotelName.text!) \(currentCell.lblPersons.text!) \(currentCell.lblDate.text!)"
        self.navigationController?.pushViewController(nxt, animated: true)
    }
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].orders
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 44
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 25)
        header.contentView.backgroundColor = UIColor.lightGray
    }
    */
    
}
