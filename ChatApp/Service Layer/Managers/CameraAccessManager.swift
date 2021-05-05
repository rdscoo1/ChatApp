//
//  CameraAccessManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 30.04.2021.
//

import UIKit
import AVFoundation

protocol ICameraAccessManager {
    func displayAlertPushToAppSettings() -> UIAlertController
    func checkCameraPermission() -> Bool
}

class CameraAccessManager: ICameraAccessManager {
    func checkCameraPermission() -> Bool {
        guard UIImagePickerController.isCameraDeviceAvailable(.rear) || UIImagePickerController.isCameraDeviceAvailable(.front) else {
            return false
        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            var result = false
            let sem = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                result = success
                sem.signal()
            }
            sem.wait()
            return result
        @unknown default:
            return false
        }
    }
    
    func displayAlertPushToAppSettings() -> UIAlertController {
        let alertController = UIAlertController(
            title: nil,
            message: Constants.LocalizationKey.giveAccessToCamera.string,
            preferredStyle: .alert
        )
        
        let openSettingsAction = UIAlertAction(title: Constants.LocalizationKey.goToSettings.string, style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        let cancelAction = UIAlertAction(title: Constants.LocalizationKey.cancel.string, style: .default, handler: nil)
        
        alertController.addAction(openSettingsAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
