//
//  CameraAlertController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/23/21.
//

import UIKit

class CameraAlertController: UIAlertController {
    
    // MARK: - Private variables
    
    private var didTapOnCamera: (() -> Void)?
    private var didTapOnPhotoLibrary: (() -> Void)?
    private var didTapOnLoadFromPixabay: (() -> Void)?
    private var didTapOnRemove: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(didTapOnCamera: (() -> Void)?,
                     didTapOnPhotoLibrary: (() -> Void)?,
                     didTapOnLoadFromPixabay: (() -> Void)?) {
        self.init()
        self.init(title: nil, message: nil, preferredStyle: .actionSheet)
        self.didTapOnPhotoLibrary = didTapOnPhotoLibrary
        self.didTapOnCamera = didTapOnCamera
        self.didTapOnLoadFromPixabay = didTapOnLoadFromPixabay
    }
    
    convenience init(didTapOnCamera: (() -> Void)?,
                     didTapOnPhotoLibrary: (() -> Void)?,
                     didTapOnLoadFromPixabay: (() -> Void)?,
                     didTapOnRemove: (() -> Void)?) {
        self.init()
        self.init(title: nil, message: nil, preferredStyle: .actionSheet)
        self.didTapOnPhotoLibrary = didTapOnPhotoLibrary
        self.didTapOnCamera = didTapOnCamera
        self.didTapOnLoadFromPixabay = didTapOnLoadFromPixabay
        self.didTapOnRemove = didTapOnRemove
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension CameraAlertController {
    
    // MARK: - Private methods
    
    private func configure() {
        view.tintColor = Constants.Colors.alertText
        addMainActions()
    }
    
    func addRemoveAction(didTapOnRemove: @escaping () -> Void) {
        let removeAction = UIAlertAction(title: Constants.LocalizationKey.deletePhoto.string, style: .destructive) { _ in
            didTapOnRemove()
        }
        addAction(removeAction)
    }
    
    private func addMainActions() {
        let cameraAction = UIAlertAction(title: Constants.LocalizationKey.makePhoto.string, style: .default) { _ in
            self.didTapOnCamera?()
        }
        
        let libraryAction = UIAlertAction(title: Constants.LocalizationKey.selectFromGallery.string, style: .default) { _ in
            self.didTapOnPhotoLibrary?()
        }
        
        let loadFromPixabay = UIAlertAction(title: Constants.LocalizationKey.loadFromPixabay.string, style: .default) { _ in
            self.didTapOnLoadFromPixabay?()
        }
        
        let cancelAction = UIAlertAction(title: Constants.LocalizationKey.cancel.string, style: .cancel, handler: nil)
        
        [cameraAction, libraryAction, loadFromPixabay, cancelAction].forEach {
            addAction($0)
        }
    }
    
}
