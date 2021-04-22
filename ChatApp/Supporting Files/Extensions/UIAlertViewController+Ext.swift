//
//  UIAlertViewController+Ext.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
