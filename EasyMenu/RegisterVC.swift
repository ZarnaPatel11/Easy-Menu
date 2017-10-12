//
//  RegisterVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 15/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterVC: Base, UITextFieldDelegate {

    // MARK: - Outlet -
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Delegate Method -
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet =  NSCharacterSet.letters
        
        return (string.rangeOfCharacter(from: characterSet) != nil)
    }

    //MARK: - Button Action -
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userLogin(_ sender: UIButton) {
        
        isValidUser()
    }
    
    // MARK: - Function -
    
    func isValidUser(){
        
        if self.txtEmail.text!.isEmpty  && self.txtFirstName.text!.isEmpty && self.txtLastName.text!.isEmpty && self.txtPassword.text!.isEmpty{
            
            self.DAlert(self.ALERT_TITLE, message: self.ALERT_BLANK_AllREQUIRED, action: self.ALERT_OK, sender: self)
        }
        else if(self.txtEmail.text!.isEmpty){
            
            self.DAlert(self.ALERT_TITLE, message: self.ALERT_BLANK_EMAIL, action: self.ALERT_OK, sender: self)
        }
        else if(self.txtFirstName.text!.isEmpty){
            
            self.DAlert(self.ALERT_TITLE, message: self.ALERT_BLANK_FNAME, action: self.ALERT_OK, sender: self)
        }
        else if(self.txtLastName.text!.isEmpty){
            
            self.DAlert(self.ALERT_TITLE, message: self.ALERT_BLANK_LNAME, action: self.ALERT_OK, sender: self)
        }
        else if(self.txtPassword.text!.isEmpty){
            
            self.DAlert(self.ALERT_TITLE, message: self.ALERT_BLANK_PASSWORD, action: self.ALERT_OK, sender: self)
        }
        else{
            
            self.CraeteUser()
        }
    }
    
    func CraeteUser(){
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if error == nil {
                
                self.AddNewUser(fName: self.txtFirstName.text!, lName: self.txtLastName.text!, emailId: self.txtEmail.text!)
                
            } else {
                
                self.DAlert(self.ALERT_TITLE, message: (error?.localizedDescription)!, action: self.ALERT_OK, sender: self)
            }
        }
    }
    func AddNewUser(fName:String, lName:String, emailId:String){
        
        let userDict : NSDictionary = ["first_name":fName,"last_name":lName,"email_id":emailId]
        let userRef = appDelegate.databaseRef.child(FTB_MyUsers).child((Auth.auth().currentUser?.uid)!)
        
        userRef.setValue(userDict){ (error, ref) in
            
            if error == nil{
                
                print("You have successfully signed up")
                UserDefaults.standard.set(self.txtFirstName.text!, forKey: "userId")
                let nxt = self.storyboard?.instantiateViewController(withIdentifier: self.STORYBOARD_IDENTIFIER_HomeVC) as! HomeVC
                self.navigationController?.pushViewController(nxt, animated: true)
            }
        }
    }
}
