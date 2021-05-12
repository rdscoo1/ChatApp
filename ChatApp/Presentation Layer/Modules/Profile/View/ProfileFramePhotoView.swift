//
//  ProfileFramePhotoView.swift
//  ChatApp
//
//  Created by Roman Khodukin on 24.04.2021.
//

import UIKit

protocol ProfileFramePhotoViewDelegate: AnyObject {
    func tappedProfileLogoImageView()
}

class ProfileFramePhotoView: UIView {
    
    // MARK: - Private Properties
    
    private lazy var frameImageView: UIImageView = {
        let imageView = UIImageView(image: .profilePhotoFrame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Constants.Colors.blue
        return imageView
    }()
    
    private lazy var editPencilImageView: UIImageView = {
        let imageView = UIImageView(image: .pencilIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editPencilContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = Themes.current.colors.primaryBackground
        return view
    }()
    
    let profilePhotoView = ProfilePhotoView()

    weak var delegate: ProfileFramePhotoViewDelegate?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        handleTap()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        handleTap()
        setupLayout()
    }
    
    // Touch only inside bounds of rounded view
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let circlePath = UIBezierPath(ovalIn: self.bounds)
        return circlePath.contains(point)
    }
    
    // MARK: - Public Methods
    
    func setLogo(image: UIImage?, fullName: String?) {
        profilePhotoView.setLogo(image: image, fullName: fullName)
        profilePhotoView.setPlaceholderLetters(fullName: fullName)
    }
    
    // MARK: - Private Methods
    
    private func handleTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        addGestureRecognizer(tap)
    }
    
    private func setupLayout() {
        editPencilContainerView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        editPencilContainerView.addSubview(editPencilImageView)
        addSubview(frameImageView)
        frameImageView.addSubview(profilePhotoView)
        frameImageView.addSubview(editPencilContainerView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),
            
            frameImageView.topAnchor.constraint(equalTo: topAnchor),
            frameImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            profilePhotoView.topAnchor.constraint(equalTo: frameImageView.topAnchor, constant: 36),
            profilePhotoView.leadingAnchor.constraint(equalTo: frameImageView.leadingAnchor, constant: 36),
            profilePhotoView.trailingAnchor.constraint(equalTo: frameImageView.trailingAnchor, constant: -36),
            profilePhotoView.bottomAnchor.constraint(equalTo: frameImageView.bottomAnchor, constant: -36),
            
            editPencilContainerView.heightAnchor.constraint(equalToConstant: 34),
            editPencilContainerView.widthAnchor.constraint(equalTo: editPencilContainerView.heightAnchor),
            editPencilContainerView.bottomAnchor.constraint(equalTo: profilePhotoView.bottomAnchor, constant: -6),
            editPencilContainerView.trailingAnchor.constraint(equalTo: profilePhotoView.trailingAnchor, constant: -6),
            
            editPencilImageView.heightAnchor.constraint(equalToConstant: 28),
            editPencilImageView.widthAnchor.constraint(equalTo: editPencilImageView.heightAnchor),
            editPencilImageView.centerYAnchor.constraint(equalTo: editPencilContainerView.centerYAnchor),
            editPencilImageView.centerXAnchor.constraint(equalTo: editPencilContainerView.centerXAnchor)
        ])
    }
    
    @objc private func imageViewTapped(_: UITapGestureRecognizer) {
        delegate?.tappedProfileLogoImageView()
    }
}

// MARK: - ConfigurableView

// extension ProfileFramePhotoView: ConfigurableView {
//    func configure(with model: UserViewModel) {
//        photoImageView.image = model.profileImage
//        initialsLabel.isHidden = model.profileImage != nil
//        setPlaceholderLetters(fullName: model.fullName)
//    }
// }
