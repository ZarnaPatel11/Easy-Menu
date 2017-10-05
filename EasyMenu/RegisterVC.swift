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

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    var ref:DatabaseReference?
    var handle:DatabaseHandle?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet =  NSCharacterSet.letters
        
        return (string.rangeOfCharacter(from: characterSet) != nil)
    }

    @IBAction func userLogin(_ sender: UIButton) {
        if txtEmail.text == "" && txtFirstName.text == "" && txtLastName.text == "" && txtPassword.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
                if error == nil {
                    self.AddNewUser()
                    print("You have successfully signed up")
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
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func AddNewUser()
    {
        ref = Database.database().reference().child("MyUsers")
        let firstName = txtFirstName.text
        let lastName = txtLastName.text
        let emailId = txtEmail.text
        let replacedEmail = emailId?.replacingOccurrences(of: ".", with: ",")
        UserDefaults.standard.set(replacedEmail!, forKey: "userId")
        let users = ["first_name":firstName,"last_name":lastName,"email_id":emailId]
        ref?.child(replacedEmail!).setValue(users)
    }
}
