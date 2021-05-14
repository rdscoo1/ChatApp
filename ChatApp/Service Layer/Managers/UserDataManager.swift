//
//  UserDataManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/26/21.
//

import Foundation

protocol IUserDataManager {
    var identifier: String { get }
    var profile: UserViewModel? { get }
    func saveProfile(_ profile: UserViewModel, completion: @escaping (Bool) -> Void)
    func loadProfile(completion: @escaping (UserViewModel) -> Void)
}

class UserDataManager: IUserDataManager {

    static var shared: IUserDataManager = UserDataManager()

    // MARK: - Private Properties

    private let userStorageManager: IUserStorageManager

    private static var keyIdentifier = "userId"

    private var id: String?

    private(set) var profile: UserViewModel?
    
    // MARK: - Init
    
    init(userStorageManager: IUserStorageManager = GCDProfileDataManager()) {
        self.userStorageManager = userStorageManager
    }

    // MARK: - Public Properties

    var identifier: String {
        if let id = id {
            return id
        } else if let id = UserDefaults.standard.string(forKey: Self.keyIdentifier) {
            self.id = id
            return id
        } else {
            let id = UUID().uuidString
            UserDefaults.standard.setValue(id, forKey: Self.keyIdentifier)
            self.id = id
            return id
        }
    }

    func saveProfile(_ profile: UserViewModel, completion: @escaping (Bool) -> Void) {
        userStorageManager.saveUserData(profile, completion: completion)
    }

    func loadProfile(completion: @escaping (UserViewModel) -> Void) {
        userStorageManager.loadUserData { profile in
            if let profile = profile {
                self.profile = profile
                completion(profile)
            } else {
                let initialProfile = UserViewModel(fullName: "Roman Khodukin",
                                                   description: "iOS developer\nMoscow, Russia",
                                                   profileImage: nil)
                self.userStorageManager.saveUserData(initialProfile) { _ in
                    self.profile = initialProfile
                    completion(initialProfile)
                }
            }
        }
    }
}


