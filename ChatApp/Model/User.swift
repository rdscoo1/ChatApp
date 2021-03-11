//
//  User.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/5/21.
//

import UIKit

struct User {
    var firstName: String
    var secondName: String?
    var profileImage: UIImage?
    
    var fullName: String {
        guard let secondName = secondName else {
            return "\(firstName)"
        }
        return "\(firstName) \(secondName)"
    }
}
