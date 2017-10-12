//
//  Constants.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 19/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    static let AddedBlue = UIColor(colorLiteralRed: 29.0/255.0, green: 161.0/255.0, blue: 242.0/255.0, alpha: 1.0)
}

class Base: UIViewController {
 
    
    //MARK: - Property -
    
    // Firebase Table
    let FTB_MyUsers = "MyUsers"
    
    // Alert Control
    let ALERT_TITLE = "EasyMenu"
    let ALERT_OK = "OK"
    
    let ALERT_BLANK_AllREQUIRED               = "Please fill all required fields "
    let ALERT_BLANK_EMAIL                     = "Please enter your email address"
    let ALERT_BLANK_FNAME                     = "Please enter your First Name"
    let ALERT_BLANK_LNAME                     = "Please enter your Last Name"
    let ALERT_BLANK_PASSWORD                  = "Please enter your password"
    
    let STORYBOARD_IDENTIFIER_RegisterVC           = "RegisterVC"
    let STORYBOARD_IDENTIFIER_HomeVC               = "HomeVC"
    let STORYBOARD_IDENTIFIER_OrderDetailVC        = "OrderDetailVC"
    let STORYBOARD_IDENTIFIER_AddItemVC            = "AddItemVC"
    let STORYBOARD_IDENTIFIER_SignInVC             = "SignInVC"
    let STORYBOARD_IDENTIFIER_AddNewItemVC         = "AddNewItemVC"
    
    //MARK: - View Life Cycle -
    
  
    
    //MARK: - Function -
    
    func DAlert(_ title: String, message: String, action: String, sender: UIViewController){
        
        let alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default, handler: nil)
        alertController.addAction(action)
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }


}
