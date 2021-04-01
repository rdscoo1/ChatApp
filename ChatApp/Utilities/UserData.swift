//
//  UserData.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/26/21.
//

import Foundation

class UserData {

    static var shared: UserData = UserData()
    private let gcdDataManager: AsyncManager = GCDAsyncManager()

    private init() { }

    private static var keyIdentifier = "userId"

    private var id: String?

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

    var name: String {
        return "Roman Khodukin"
    }

}
