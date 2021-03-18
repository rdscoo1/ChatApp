//
//  DataManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/19/21.
//

import Foundation

protocol DataManager {
    func loadUserData(completion: @escaping (UserViewModel?) -> ())
    func saveUserData(_ user: UserViewModel, completion: ((Bool) -> ())?)
}
