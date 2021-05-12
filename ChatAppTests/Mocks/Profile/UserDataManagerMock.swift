//
//  UserDataManagerMock.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 07.05.2021.
//

@testable import ChatApp
import Foundation

class UserDataManagerMock: IUserDataManager {
    
    // MARK: - Counters
    
    private(set) var saveProfileCount = 0
    private(set) var loadProfileCount = 0
    private(set) var saveProfileImageCount = 0
    private(set) var loadProfileImageCount = 0
    private(set) var getProfileIdCount = 0
    private(set) var getProfileCount = 0
    
    // MARK: - Public Properties
    
    var idetifierReturn = "testId"
    var isUserDataSaved = false
    var userId = ""
    
    // MARK: - Gettable Properties
    
    private(set) var returnedImageFileName: String?
    private(set) var returnedUser: UserViewModel?
    private(set) var defaultProfile = UserViewModel(fullName: "Test User", description: "iOS Developer", profileImage: nil)
    
    var identifier: String {
        getProfileIdCount += 1
        return idetifierReturn
    }
    
    var profile: UserViewModel? {
        getProfileCount += 1
        return defaultProfile
    }
    
    func saveProfile(_ profile: UserViewModel, completion: @escaping (Bool) -> Void) {
        saveProfileCount += 1
        returnedUser = profile
        completion(isUserDataSaved)
    }
    
    func loadProfile(completion: @escaping (UserViewModel) -> Void) {
        loadProfileCount += 1
        completion(returnedUser ?? UserViewModel(fullName: "", description: "", profileImage: nil))
    }
    
}
