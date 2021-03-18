//
//  User.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/5/21.
//

import UIKit

struct User: Codable {
    var fullName: String
    let description: String?
    let profileImageUrl: URL?
}
