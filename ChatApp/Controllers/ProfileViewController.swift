//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let profileLogoImageView = ProfileLogoImageView()
    
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Roman Khodukin"
        return label
    }()
    
    private lazy var profileCareerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "UX/UI designer, iOS-developer"
        return label
    }()
    
    private lazy var profileGeoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Moscow, Russia"
        return label
    }()
    
    private let saveButton = ActionButton(title: Constants.LocalizationKey.save.string)
    
    private let offset: CGFloat = 16
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Themes.current.statusBarStyle
    }
        
    // MARK: - LifeCycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.LocalizationKey.close.string,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissVC))
        navigationItem.title = Constants.LocalizationKey.myProfile.string
        
        
        profileLogoImageView.delegate = self
        profileLogoImageView.setPlaceholderLetters(fullName: profileNameLabel.text)
        
        setupTheme()
        configureConstraints()
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Private Methods
    
    private func setupTheme() {
        let theme = Themes.current
        view.backgroundColor = theme.colors.primaryBackground
        profileNameLabel.textColor = theme.colors.profile.name
        profileCareerLabel.textColor = theme.colors.profile.description
        profileCareerLabel.textColor = theme.colors.profile.description
        saveButton.backgroundColor = theme.colors.profile.saveButtonBackground
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor:theme.colors.navigationBar.title]
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
    
    private func configureConstraints() {
        view.addSubview(profileLogoImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(profileCareerLabel)
        view.addSubview(profileGeoLabel)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            profileLogoImageView.widthAnchor.constraint(equalToConstant: offset * 15),
            profileLogoImageView.heightAnchor.constraint(equalTo: profileLogoImageView.widthAnchor),
            profileLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset * 3),
            profileLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileNameLabel.topAnchor.constraint(equalTo: profileLogoImageView.bottomAnchor, constant: offset * 2),
            profileNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            
            profileCareerLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: offset * 2),
            profileCareerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            profileCareerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            
            profileGeoLabel.topAnchor.constraint(equalTo: profileCareerLabel.bottomAnchor, constant: offset / 4),
            profileGeoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            profileGeoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            
            saveButton.heightAnchor.constraint(equalToConstant: offset * 3),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset * 3),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset * 3),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset * 2)
        ])
    }
    
}

// MARK: - ProfileLogoImageViewDelegate Conformance

extension ProfileViewController: ProfileLogoImageViewDelegate {
    func tappedProfileLogoImageView() {
        ImagePickerManager().pickImage(self) { image in
            guard let image = image else { return }
            self.profileLogoImageView.setLogo(image: image)
        }
    }
}
