//
//  ViewController.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 14/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignInVC: Base, UITextFieldDelegate {
    
    var tField: UITextField!
    
    // MARK: - Outlet -
    
    @IBOutlet weak var txtEmail: DesignableTextField!
    @IBOutlet weak var txtPassword: DesignableTextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    //MARK: - Delegate Method -
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: - Action -
    
    @IBAction func userLogin(_ sender: UIButton) {
        
        if (self.txtEmail.text?.isEmpty)! && (self.txtPassword.text?.isEmpty)! {
            
            self.DAlert(ALERT_TITLE, message: "Please enter an email and password.", action: ALERT_OK, sender: self)
            
        } else {
            
            self.signIn(emailId: self.txtEmail.text!, password: self.txtPassword.text!)
        }
    }
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Email?", message: "Please input your email:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userEmail")
                UserDefaults.standard.synchronize()
                Auth.auth().sendPasswordReset(withEmail: self.tField.text!, completion: { (error) in
                    var title = ""
                    var message = ""
                    if error != nil {
                        title = "Error!"
                        message = (error?.localizedDescription)!
                    } else {
                        title = "Success!"
                        message = "Password reset email sent."
                        //self.txtEmail.text = ""
                    }
                    self.DAlert(title, message: message, action: self.ALERT_OK, sender: self)
                })

            } else {
                // user did not fill field
                //self.DAlert(ALERT_TITLE, message: "Please enter an email.", action: ALERT_OK, sender: self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
            self.tField = textField
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        
        let nxt = storyboard?.instantiateViewController(withIdentifier: STORYBOARD_IDENTIFIER_RegisterVC) as! RegisterVC
        self.navigationController?.pushViewController(nxt, animated: true)
    }
    
    //MARK: - Function -
    
    func signIn(emailId:String, password:String){
        
        Auth.auth().signIn(withEmail: emailId, password: password) { (user, error) in
            if error == nil {
                
                let replacedEmail = emailId.replacingOccurrences(of: ".", with: ",")
                UserDefaults.standard.set(replacedEmail, forKey: "userId")
                
                print("You have successfully logged in")
                let nxt = self.storyboard?.instantiateViewController(withIdentifier: self.STORYBOARD_IDENTIFIER_HomeVC) as! HomeVC
                self.navigationController?.pushViewController(nxt, animated: true)
            } else {
                
                self.DAlert(self.ALERT_TITLE, message: "There is no user record corresponding to this identifier.", action: self.ALERT_OK, sender: self)
            }
        }
    }
}

