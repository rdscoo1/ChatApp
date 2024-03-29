//
//  IUserStorageManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/19/21.
//

import Foundation

protocol IUserStorageManager {
    func loadUserData(completion: @escaping (UserViewModel?) -> Void)
    func saveUserData(_ user: UserViewModel, completion: ((Bool) -> Void)?)
}
