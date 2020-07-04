//
//  UIViewController+ShowAlert.swift
//  Sakaly
//
//  Created by Ziad on 7/2/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
