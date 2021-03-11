//
//  String+Ext.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/4/21.
//

import Foundation

extension String {
    
    /// Returns a localized string pulled from `Localizable.strings` by its key.
    public var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
