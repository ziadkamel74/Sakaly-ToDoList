//
//  UIButton+CornerRaduis.swift
//  Sakaly
//
//  Created by Ziad on 7/2/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
}
