//
//  File.swift
//  test
//
//  Created by stephendsw on 16/5/19.
//  Copyright © 2016年 qtyd. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor : UIColor {
        get {
            return UIColor(cgColor : layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}
