//
//  TextAccessTo.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/23/21.
//

import Foundation

extension Constants {
    enum LocalizationKey: String {
        
        // Titles
        case chat = "Chat"
        case myProfile = "My profile"
        case settings = "Settings"
        
        // ImagePicker
        case giveAccessToCamera = "To add photo give access to camera in device settings"
        case goToSettings = "Go to settings"
        case noAccessToCamera = "No access to camera"
        
        // CameraAlert Actions
        case deletePhoto = "Delete Photo"
        case makePhoto = "Make photo"
        case selectFromGallery = "Select from gallery"
        
        // App theme title
        case classic = "Classic"
        case day = "Day"
        case night = "Night"
        
        // Basic
        case save = "Save"
        case close = "Close"
        case cancel = "Cancel"
        case error = "Error"
        case okay = "Okay"
        
        var string: String {
            return rawValue.localized
        }
    }
}
