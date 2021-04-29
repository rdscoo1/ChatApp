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
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        addSubview(frameImageView)
        frameImageView.addSubview(profilePhotoView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),
            
            frameImageView.topAnchor.constraint(equalTo: topAnchor),
            frameImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            profilePhotoView.topAnchor.constraint(equalTo: frameImageView.topAnchor, constant: 40),
            profilePhotoView.leadingAnchor.constraint(equalTo: frameImageView.leadingAnchor, constant: 40),
            profilePhotoView.trailingAnchor.constraint(equalTo: frameImageView.trailingAnchor, constant: -40),
            profilePhotoView.bottomAnchor.constraint(equalTo: frameImageView.bottomAnchor, constant: -40)
        ])
    }
    
    @objc private func imageViewTapped(_: UITapGestureRecognizer) {
        print(#function)
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
