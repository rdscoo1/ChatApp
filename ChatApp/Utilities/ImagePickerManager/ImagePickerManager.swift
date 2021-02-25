//
//  ImagePickerManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/23/21.
//

import UIKit
import AVFoundation

class ImagePickerManager: NSObject, UINavigationControllerDelegate {
    
    // MARK: - Private Properties
    
    private let picker = UIImagePickerController()
    private var alertController: CameraAlertController?
    private var presentationController: UIViewController?
    private var pickImageCallback: ((UIImage?) -> ())?
    
    // MARK: - Initialization
    
    override init(){
        super.init()
        
        alertController = CameraAlertController(
            didTapOnCamera: ({
                self.checkCameraPermission()
            }),
            didTapOnPhotoLibrary: ({
                self.openImagePickerOfType(.photoLibrary)
            }))
        
        alertController?.pruneNegativeWidthConstraints()
        picker.delegate = self
    }
    
    // MARK: - Public Method
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage?) -> ())) {
        pickImageCallback = callback
        presentationController = viewController
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController?.popoverPresentationController?.sourceView = presentationController?.view
            alertController?.popoverPresentationController?.sourceRect = presentationController!.view.bounds
            alertController?.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        viewController.present(alertController ?? UIAlertController(title: "hi", message: "by", preferredStyle: .alert), animated: true)
    }
    
    // MARK: - Private Methods
    
    private func openImagePickerOfType(_ sourceType: UIImagePickerController.SourceType) {
        alertController?.dismiss(animated: true, completion: nil)
        if(UIImagePickerController.isSourceTypeAvailable(sourceType)) {
            picker.sourceType = sourceType
            if sourceType == .camera {
                picker.cameraDevice = .front
            }
            presentationController?.present(picker, animated: true)
        } else {
            presentCameraErrorAlert()
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.openImagePickerOfType(.camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openImagePickerOfType(.camera)
                } else {
                    self.displayAlertPushToAppSettings(for: .cameraProfile)
                }
            }
        case .denied, .restricted:
            self.displayAlertPushToAppSettings(for: .cameraProfile)
        default:
            displayAlertPushToAppSettings(for: .cameraProfile)
        }
    }
    
    private func displayAlertPushToAppSettings(for typeMessage: Constants.TextAccessTo, onCancel: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: nil,
            message: typeMessage.rawValue,
            preferredStyle: .alert
        )
        
        let openSettingsAction = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            self.presentationController?.dismiss(animated: true)
            onCancel?()
        }
        
        alertController.addAction(openSettingsAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.presentationController?.present(alertController, animated: true)
        }
    }
    
    private func presentCameraErrorAlert() {
        let haptic: HapticFeedback = .error
        let alertVC = UIAlertController(title: "Ошибка", message: "Нет доступа к камере", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Окей", style: .cancel) { _ in }
        alertVC.addAction(dismissAction)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        haptic.impact()
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePickerManager: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[.originalImage] as? UIImage {
            pickImageCallback?(originalImage)
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
