//
//  UIWindow+Ext.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/10/21.
//

import UIKit

public extension UIWindow {

    /// Unload all views and add them back
    /// Used for applying `UIAppearance` changes to existing views
    func reload() {
        subviews.forEach { view in
            view.removeFromSuperview()
            addSubview(view)
        }
    }
}
