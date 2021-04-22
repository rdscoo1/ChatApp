//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/15/21.
//

import Foundation

protocol ICoreAssembly {
    func coreDataManager() -> CoreDataManager
    func profileDataManager() -> IProfileDataManager
}

class CoreAssembly: ICoreAssembly {
    func coreDataManager() -> CoreDataManager {
        return CoreDataManager.shared
    }

    func profileDataManager() -> IProfileDataManager {
        return GCDProfileDataManager()
    }
}
