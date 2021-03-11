//
//  Date+Ext.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/4/21.
//

import Foundation

extension Date {
    
    func formatted(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var isDateInToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
