//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Public properties
    
    var profileDataUpdatedHandler: (() -> Void)?
    
    // MARK: - UI
    
    private let profileLogoImageView = ProfileLogoImageView()
    
    private lazy var profileNameTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Roman Khodukin"
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.textAlignment = .center
        textView.bouncesZoom = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var profileDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "iOS Developer\nMoscow, Russia"
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let editButton = ActionButton(title: Constants.LocalizationKey.edit.string)
    
    private let saveButton = ActionButton(title: Constants.LocalizationKey.save.string)
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private Properties
    
    private let gcdDataManager: AsyncManager = GCDAsyncManager()
    private let operationDataManager: AsyncManager = OperationAsyncManager()
    
    private var user: UserViewModel?
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
        activityIndicator.startAnimating()
        let dataManager = gcdDataManager
        
        dataManager.loadUserData { [weak self] userViewModel in
            guard let user = userViewModel else {
                self?.showAlert(title: Constants.LocalizationKey.error.string, message: Constants.LocalizationKey.failedDataSave.string, additionalActions:
                                    [.init(title: Constants.LocalizationKey.tryAgain.string, style: .default) { [weak self] _ in
                                        self?.loadData()
                                    }]) { [weak self] _ in
                    self?.dismissVC()
                }
                return
            }
            
            self?.user = user
            self?.originalUserImage = user.profileImage
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
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
    }
    
    private func saveButtonPressed(dataManager: AsyncManager) {
        exitEditMode()
        activityIndicator.startAnimating()
        dataManager.saveUserData(userModel) { [weak self] (isSuccessful: Bool) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
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
                                        self?.saveButtonPressed(dataManager: dataManager)
                                    }]) { [weak self] _ in
                    self?.setSaveButtonsEnabled(true)
                }
            }
        }
    }
    
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
    
    // MARK: - Setup Theme
    
    private func setupTheme() {
        let theme = Themes.current
        view.backgroundColor = theme.colors.primaryBackground
        activityIndicator.backgroundColor = theme.colors.primaryBackground
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
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        saveButton.isEnabled = false
        saveButton.isHidden = true
        
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(gcdSaveButtonPressed), for: .touchUpInside)
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
    
    @objc private func gcdSaveButtonPressed() {
        saveButtonPressed(dataManager: gcdDataManager)
    }
    
    @objc private func operationsButtonPressed() {
        saveButtonPressed(dataManager: operationDataManager)
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

// MARK: - ProfileLogoImageViewDelegate Conformance

extension ProfileViewController: ProfileLogoImageViewDelegate {
    func tappedProfileLogoImageView() {
        
        ImagePickerManager().pickImage(self) { image in
            self.setSaveButtonsEnabled(image != nil || self.nameChanged || self.descriptionChanged)
            
            guard let image = image else { return }
            self.profileLogoImageView.setLogo(image: image)
        }
    }
}
