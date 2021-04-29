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
        case channels = "Channels"
        case myProfile = "My profile"
        case settings = "Settings"
        case imagesFromPixabay = "Images from Pixabay"

        // Profile
        case dataSuccessSave = "Data saved successfully"
        case failedDataSave = "Failed to save data"
        case actionNotAllowed = "This action is not allowed"

        // ImagePicker
        case giveAccessToCamera = "To add photo give access to camera in device settings"
        case goToSettings = "Go to settings"
        case noAccessToCamera = "No access to camera"
        
        // CameraAlert Actions
        case deletePhoto = "Delete photo"
        case makePhoto = "Make photo"
        case selectFromGallery = "Select from gallery"
        case loadFromPixabay = "Load from Pixabay"

        // Channels
        case create = "Create"
        case createNewChannel = "Create new channel"
        case enterChannelName = "Enter channel name here..."
        case errorChannelNameIsEmpty = "Channel name can't be empty."
        case errorDuringChannelCreation = "Error occurred during creating new channel, try again later."

        // Conversation
        case errorDuringSendingMessage = "Error occurred during sending new message, try again later."

        // App theme title
        case classic = "Classic"
        case day = "Day"
        case night = "Night"
        
        // Basic
        case save = "Save"
        case close = "Close"
        case cancel = "Cancel"
        case error = "Error occurred"
        case failedLoadingImage = "Failed to load image"
        case okay = "Okay"
        case edit = "Edit"
        case success = "Success"
        case tryAgain = "Try again"
        
        var string: String {
            return rawValue.localized
        }
    }
}
