//
//  Constants.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/18/21.
//

import Foundation

struct Constants {
    
    static let baseUrl = "pixabay.com" // "https://pixabay.com/api/"
    
    enum ViewControllerState: String {
        case loading = "Loading"
        case loaded = "Loaded"
        case appearing = "Appearing"
        case appeared = "Appeared"
        case disappearing = "Disappearing"
        case disappeared = "Disappeared"
    }
    
    static let userDataFileName = "userData.json"
    static let userImageFileName = "userImage.png"
    
}
