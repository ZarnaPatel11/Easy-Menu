//
//  DesignableView.swift
//  EasyMenu
//
//  Created by Zarna M. Patel on 19/09/17.
//  Copyright © 2017 Zarna M. Patel. All rights reserved.
//

import UIKit

class DesignableView: UIView {
   
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
