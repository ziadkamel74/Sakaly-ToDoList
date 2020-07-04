//
//  ext.swift
//  Sakaly
//
//  Created by Ziad on 5/14/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
