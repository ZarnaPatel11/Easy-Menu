//
//  SplashVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 29/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit

class SplashVC: Base {
    
    //Mark: - Properties
    var loggedIn:Bool = false

    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // Checks loggedIn condition of user
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        if loggedIn {
            
            let nxt = self.storyboard?.instantiateViewController(withIdentifier: self.STORYBOARD_IDENTIFIER_HomeVC) as! HomeVC
            self.navigationController?.pushViewController(nxt, animated: true)
        } else {
            
            let rootNavVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
            let nxt = self.storyboard?.instantiateViewController(withIdentifier: self.STORYBOARD_IDENTIFIER_SignInVC) as! SignInVC
            rootNavVC.setViewControllers([nxt], animated: true)
        }
    }
}
