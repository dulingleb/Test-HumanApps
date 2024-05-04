//
//  Alert.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 4.5.24..
//

import Foundation
import UIKit

class Alert {
    static func set(message: String, title: String?) -> UIAlertController {
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertMessagePopUpBox.addAction(okButton)
        return alertMessagePopUpBox
    }
}
