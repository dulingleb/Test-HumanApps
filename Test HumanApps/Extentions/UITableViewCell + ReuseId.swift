//
//  UITableViewCell + ReuseId.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 4.5.24..
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
