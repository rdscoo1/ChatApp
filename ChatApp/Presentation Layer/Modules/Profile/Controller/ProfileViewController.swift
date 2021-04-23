//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presentationAssembly: IPresentationAssembly?

    var user: UserViewModel?

    var userDataManager: IUserDataManager?
    
    var profileDataUpdatedHandler: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let profileLogoImageView = ProfileLogoImageView()
    
    private lazy var profileNameTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Roman Khodukin"
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.textAlignment = .center
        textView.bouncesZoom = true
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var profileDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "iOS Developer\nMoscow, Russia"
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let editButton = ActionButton(title: Constants.LocalizationKey.edit.string)
    
    private let saveButton = ActionButton(title: Constants.LocalizationKey.save.string)
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
        
    // MARK: - Private Properties
    
    private var userModel: UserViewModel {
        .init(fullName: profileNameTextView.text,
              description: profileDescriptionTextView.text,
              profileImage: user?.profileImage)
    }
    
    private let offset: CGFloat = 16
    
    private var profileNameBottomConstraint: NSLayoutConstraint!
    private var profileDescriptionBottomConstraint: NSLayoutConstraint!
    
    private var originalUserImage: UIImage?
    private var nameChanged = false
    private var descriptionChanged = false
    private var imageChanged = false
    
    // MARK: - TextView Delegates
    
    private lazy var nameTextViewDelegate = TextViewDelegate(textViewType: .nameTextView) { [weak self] in
        var textChanged = self?.user?.fullName != self?.profileNameTextView.text
        self?.nameChanged = textChanged
        self?.setSaveButtonsEnabled(textChanged || self?.descriptionChanged ?? true)
    }
    private lazy var descriptionTextViewDelegate = TextViewDelegate(textViewType: .descriptionTextView) { [weak self] in
        var textChanged = self?.user?.description != self?.profileDescriptionTextView.text
        self?.descriptionChanged = textChanged
        self?.setSaveButtonsEnabled(textChanged || self?.nameChanged ?? true)
    }
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - LifeCycle 
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Themes.current.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        profileLogoImageView.delegate = self
        profileLogoImageView.setPlaceholderLetters(fullName: profileNameTextView.text)
        
        setupTheme()
        configureConstraints()
        setupUI()
        loadData()
    }
    
    // MARK: - Private Methods
    
    private func loadData() {
        activityIndicatorView.startAnimating()
        userDataManager?.loadProfile { [weak self] userViewModel in
            self?.user = userViewModel
            self?.originalUserImage = userViewModel.profileImage
            
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
                self?.setupTextViews()
                //                self?.setProfileImage(image: user.profileImage)
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func exitEditMode() {
        if profileNameTextView.isUserInteractionEnabled {
            toggleEditMode()
        }
        setSaveButtonsEnabled(false)
    }
    
    private func setSaveButtonsEnabled(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        let saveButtonHiddenState = profileNameTextView.isUserInteractionEnabled ? true : false
    }
    
    private func saveButtonPressed() {
        exitEditMode()
        activityIndicatorView.startAnimating()
        userDataManager?.saveProfile(userModel) { [weak self] (isSuccessful: Bool) in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
            }
            if isSuccessful {
                if let profileDataUpdatedHandler = self?.profileDataUpdatedHandler {
                    profileDataUpdatedHandler()
                }
                
                DispatchQueue.main.async {
                    if self?.profileLogoImageView == nil {
                        self?.profileLogoImageView.setPlaceholderLetters(fullName: self?.profileNameTextView.text)
                    }
                    self?.originalUserImage = self?.user?.profileImage
                    self?.nameChanged = false
                    self?.descriptionChanged = false
                    self?.showAlert(title: Constants.LocalizationKey.success.string, message: Constants.LocalizationKey.dataSuccessSave.string)
                }
            } else {
                self?.showAlert(title: Constants.LocalizationKey.error.string, message: Constants.LocalizationKey.failedDataSave.string, additionalActions: [
                                    .init(title: Constants.LocalizationKey.tryAgain.string, style: .default) { [weak self] _ in
                                        self?.saveButtonPressed()
                                    }]) { [weak self] _ in
                    self?.setSaveButtonsEnabled(true)
                }
            }
        }
    }
    
    private func selectedProfileImage(_ image: UIImage) {
        setSaveButtonsEnabled(imageChanged || nameChanged || descriptionChanged)
        setProfileImage(image: image)
    }
    
    private func setProfileImage(image: UIImage?) {
        user?.profileImage = image
        profileLogoImageView.setLogo(image: image)
    }
    
    private func presentPixabayImagePickerViewController() {
        guard let pixabayImagePickerViewController = presentationAssembly?.pixabayImagePickerViewController(didSelectImage: { [weak self] image in
            self?.selectedProfileImage(image)
        }) else { return }
        
        if let baseNavigationController = presentationAssembly?.rootNavigationViewController(pixabayImagePickerViewController) {
            present(baseNavigationController, animated: true, completion: nil)
        }
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            showAlert()
            return
        }
        
        imagePickerController.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(self.imagePickerController, animated: true)
        }
    }
    
    // MARK: - Setup Theme
    
    private func setupTheme() {
        let theme = Themes.current
        view.backgroundColor = theme.colors.primaryBackground
        activityIndicatorView.backgroundColor = theme.colors.primaryBackground
        profileNameTextView.textColor = theme.colors.profile.name
        profileDescriptionTextView.textColor = theme.colors.profile.description
        editButton.backgroundColor = theme.colors.profile.saveButtonBackground
        saveButton.backgroundColor = theme.colors.profile.saveButtonBackground
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            navBarAppearance.backgroundColor = theme.colors.navigationBar.background
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = theme.colors.navigationBar.background
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
        }
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Setting up UI
    
    private func setupTextViews() {
        profileNameTextView.text = user?.fullName
        profileDescriptionTextView.text = user?.description
        profileNameTextView.delegate = nameTextViewDelegate
        profileDescriptionTextView.delegate = descriptionTextViewDelegate
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.LocalizationKey.close.string,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(toggleEditMode))
        navigationItem.title = Constants.LocalizationKey.myProfile.string
    }
    
    private func setupUI() {
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        saveButton.isEnabled = false
        saveButton.isHidden = true
        
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        view.addSubview(profileLogoImageView)
        view.addSubview(profileNameTextView)
        view.addSubview(profileDescriptionTextView)
        view.addSubview(editButton)
        view.addSubview(saveButton)
        
        profileNameBottomConstraint = profileNameTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        profileDescriptionBottomConstraint = profileDescriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            profileLogoImageView.widthAnchor.constraint(equalToConstant: offset * 14),
            profileLogoImageView.heightAnchor.constraint(equalToConstant: offset * 14),
            profileLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset * 2),
            profileLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileNameTextView.heightAnchor.constraint(equalToConstant: offset * 5),
            profileNameTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileNameTextView.topAnchor.constraint(equalTo: profileLogoImageView.bottomAnchor, constant: offset * 2),
            profileNameTextView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            profileNameTextView.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            
            profileDescriptionTextView.heightAnchor.constraint(equalToConstant: offset * 5),
            profileDescriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileDescriptionTextView.topAnchor.constraint(equalTo: profileNameTextView.bottomAnchor, constant: offset * 2),
            profileDescriptionTextView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            profileDescriptionTextView.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            
            editButton.heightAnchor.constraint(equalToConstant: offset * 3),
            editButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset * 2),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset * 2),
            editButton.topAnchor.constraint(greaterThanOrEqualTo: profileDescriptionTextView.bottomAnchor, constant: offset * 2),
            
            saveButton.heightAnchor.constraint(equalToConstant: offset * 3),
            saveButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: offset),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset * 2),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset * 2)
        ])
    }
    
    private func showAlert(title: String = Constants.LocalizationKey.error.string,
                           message: String = Constants.LocalizationKey.actionNotAllowed.string,
                           additionalActions: [UIAlertAction] = [],
                           primaryHandler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: Constants.LocalizationKey.okay.string, style: .cancel, handler: primaryHandler))
            additionalActions.forEach { alertController.addAction($0) }
            self.present(alertController, animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapSaveButton() {
        saveButtonPressed()
    }
    
    @objc private func toggleEditMode() {
        let backgroundColor = profileNameTextView.isUserInteractionEnabled ? nil : UIColor.lightGray
        let editButtonTitle = profileNameTextView.isUserInteractionEnabled ? Constants.LocalizationKey.edit.string : Constants.LocalizationKey.cancel.string
        let saveButtonHiddenState = profileNameTextView.isUserInteractionEnabled ? true : false
        UIView.animate(withDuration: 0.3) {
            self.editButton.setTitle(editButtonTitle, for: .normal)
            self.profileNameTextView.backgroundColor = backgroundColor
            self.profileDescriptionTextView.backgroundColor = backgroundColor
            self.saveButton.isHidden = saveButtonHiddenState
        }
        profileNameTextView.isUserInteractionEnabled.toggle()
        profileDescriptionTextView.isUserInteractionEnabled.toggle()
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    // MARK: - Keyboard Actions
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           keyboardSize.height > 0 {
            if profileNameTextView.isFirstResponder {
                profileNameBottomConstraint.constant = keyboardSize.height
                profileNameBottomConstraint.priority = .required
                profileDescriptionBottomConstraint.constant = 0
                profileDescriptionBottomConstraint.priority = UILayoutPriority(rawValue: 249)
            } else if profileDescriptionTextView.isFirstResponder {
                profileDescriptionBottomConstraint.constant = keyboardSize.height
                profileDescriptionBottomConstraint.priority = .required
                profileNameBottomConstraint.constant = 0
                profileNameBottomConstraint.priority = UILayoutPriority(rawValue: 249)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        profileNameBottomConstraint.constant = 0
        profileNameBottomConstraint.priority = UILayoutPriority(rawValue: 249)
        profileDescriptionBottomConstraint.constant = 0
        profileDescriptionBottomConstraint.priority = UILayoutPriority(rawValue: 249)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(false)
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            showAlert()
            return
        }
        
        setProfileImage(image: image)
        
//        imagePickedHandler(image)
    }
}

extension ProfileViewController: ProfileLogoImageViewDelegate {
    func tappedProfileLogoImageView() {
        if user?.profileImage != nil {
            let alertController = CameraAlertController(
                didTapOnCamera: {
                    if self.checkCameraPermission() {
                        self.presentImagePicker(sourceType: .camera)
                    } else {
                        self.showAlert()
                    }
                }, didTapOnPhotoLibrary: {
                    self.presentImagePicker(sourceType: .photoLibrary)
                }, didTapOnLoadFromPixabay: {
                    self.presentPixabayImagePickerViewController()
                }, didTapOnRemove: {
                    self.setProfileImage(image: nil)
                    let imageChanged = self.originalUserImage != nil
                    self.imageChanged = imageChanged
                    self.setSaveButtonsEnabled(imageChanged || self.nameChanged || self.descriptionChanged)
                })
            alertController.pruneNegativeWidthConstraints()
            
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = CameraAlertController(
                didTapOnCamera: {
                    if self.checkCameraPermission() {
                        self.presentImagePicker(sourceType: .camera)
                    } else {
                        self.showAlert()
                    }
                }, didTapOnPhotoLibrary: {
                    self.presentImagePicker(sourceType: .photoLibrary)
                }, didTapOnLoadFromPixabay: {
                    self.presentPixabayImagePickerViewController()
                })
            alertController.pruneNegativeWidthConstraints()
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func checkCameraPermission() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            var result: Bool = false
            let semaphore = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .video) { granted in
                result = granted
                semaphore.signal()
            }
            semaphore.wait()
            return result
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
}
