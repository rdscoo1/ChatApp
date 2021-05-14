//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/15/21.
//

import Foundation

protocol ICoreAssembly {
    func coreDataManager() -> CoreDataManager
    func userStorageManager() -> IUserStorageManager
    func networkManager() -> INetworkManager
}

class CoreAssembly: ICoreAssembly {
    func coreDataManager() -> CoreDataManager {
        return CoreDataManager.shared
    }

    func userStorageManager() -> IUserStorageManager {
        return GCDProfileDataManager()
    }
    
    func networkManager() -> INetworkManager {
        return NetworkManager()
    }
}
