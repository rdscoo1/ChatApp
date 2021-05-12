//
//  UserStorageManagerMock.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 07.05.2021.
//

import Foundation
@testable import ChatApp

class UserStorageManagerMock: IUserStorageManager {
    
    // MARK: - Counters
    
    private(set) var writeToDiskCount = 0
    private(set) var readFromDiskCount = 0
    private(set) var isUserProfileSaved = false
    
    // MARK: - Properties
    
    var userViewModel: UserViewModel?
    var returnedUserViewModel: UserViewModel?
    
    // MARK: - IProfileDataManage Conformance
    
    func loadUserData(completion: @escaping (UserViewModel?) -> Void) {
        readFromDiskCount += 1
        completion(userViewModel)
    }
    
    func saveUserData(_ user: UserViewModel, completion: ((Bool) -> Void)?) {
        writeToDiskCount += 1
        returnedUserViewModel = userViewModel
        completion?(isUserProfileSaved)
    }
}
