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

class WelcomeVC: UIViewController, UITextFieldDelegate {
    
    var ref:DatabaseReference!
    @IBOutlet weak var txtEmail: DesignableTextField!
    @IBOutlet weak var txtPassword: DesignableTextField!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
        
        
    }
    @IBAction func userLogin(_ sender: UIButton) {
        if self.txtEmail.text == "" || self.txtPassword.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (user, error) in
                if error == nil {
                    self.ref = Database.database().reference()
                    let replacedEmail = self.txtEmail.text?.replacingOccurrences(of: ".", with: ",")
                    UserDefaults.standard.set(replacedEmail, forKey: "userId")
                
                    print("You have successfully logged in")
                    let nxt = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(nxt, animated: true)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        if self.txtEmail.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.txtEmail.text!, completion: { (error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.txtEmail.text = ""
                }
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        let nxt = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(nxt, animated: true)
    }
   
}

