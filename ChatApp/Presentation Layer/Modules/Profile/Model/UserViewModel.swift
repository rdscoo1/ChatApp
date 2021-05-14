//
//  UserViewModel.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/18/21.
//

import UIKit

struct UserViewModel {
    var fullName: String
    
    var firstName: String? {
        fullName.components(separatedBy: .whitespacesAndNewlines).first
    }
    var secondName: String? {
        let words = fullName.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        return words.count > 1 ? words[1] : nil
    }
    let description: String?
    
    var profileImage: UIImage?
}

extension UserViewModel: Equatable {
    
    public static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.description == rhs.description && lhs.profileImage === rhs.profileImage
    }
}
