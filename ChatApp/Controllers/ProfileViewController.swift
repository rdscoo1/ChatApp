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
    
    private let editButton = ActionButton(title: "Save")
    
    private let offset: CGFloat = 16
        
    // MARK: - LifeCycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.appTheme
        
        configureConstraints()
        
        profileLogoImageView.delegate = self
        profileLogoImageView.setPlaceholderLetters(fullName: profileNameLabel.text)
        
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(dismissVC))
        navigationItem.title = Constants.LocalizationKey.myProfile.string
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Private Methods
    
    private func configureConstraints() {
        view.addSubview(profileLogoImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(profileCareerLabel)
        view.addSubview(profileGeoLabel)
        view.addSubview(editButton)
        
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
            
            editButton.heightAnchor.constraint(equalToConstant: offset * 3),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset * 3),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset * 3),
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset * 2)
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
