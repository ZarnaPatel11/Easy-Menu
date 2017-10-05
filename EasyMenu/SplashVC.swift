//
//  SplashVC.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 29/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    var loggedIn:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        if loggedIn {
            let nxt = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(nxt, animated: true)
        } else {
            let rootNavVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
            let nxt = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            rootNavVC.setViewControllers([nxt], animated: true)
        }
    }
}
