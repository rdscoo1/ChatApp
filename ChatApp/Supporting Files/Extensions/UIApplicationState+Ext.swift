//
//  UIApplicationState+Ext.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/18/21.
//

import UIKit

extension UIApplication.State {
    
    var description: String {
        switch self {
        case .active:
            return "Active"
        case .background:
            return "Background"
        case .inactive:
            return "Inactive"
        @unknown default:
            return "Unknown state"
        }
    }
}
