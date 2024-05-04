//
//  Icon.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 2.5.24..
//

import Foundation
import UIKit

enum Icon {
    case main
    case setting
    case book
    
    var uiImage: UIImage {
        switch self {
            case .main: return UIImage(systemName: "house")!
            case .setting: return UIImage(systemName: "gear")!
            case .book: return UIImage(systemName: "book")!
        }
    }
}
