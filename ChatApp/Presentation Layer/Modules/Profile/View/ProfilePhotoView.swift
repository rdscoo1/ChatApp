//
//  ProfilePhotoView.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit

protocol ProfilePhotoViewDelegate: AnyObject {
    func tappedProfileLogoImageView()
}

class ProfilePhotoView: UIView {
    
    // MARK: - Public properties
    
    var profileImage: UIImage? {
        photoImageView.image
    }
    
    // MARK: - Private Properties
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Constants.Colors.profileLogoBackground
        return imageView
    }()
    
    lazy var initialsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 115, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textAlignment  = .center
        
        return label
    }()
    
    weak var delegate: ProfilePhotoViewDelegate?
    
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
    
    // MARK: - Lifecycle methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
    }
    
    // MARK: - Public Methods
    
    func setLogo(image: UIImage?, fullName: String?) {
        photoImageView.image = image
        initialsLabel.isHidden = photoImageView.image != nil
        setPlaceholderLetters(fullName: fullName)
    }
    
    func setPlaceholderLetters(fullName: String?) {
        guard let fullName = fullName else { return }
        
        let wordsArr = fullName.components(separatedBy: " ")
        
        let firstNameLetter = String(wordsArr[0].prefix(1))
        initialsLabel.text = firstNameLetter

        if wordsArr.count == 2 {
            let lastNameLetter = String(wordsArr[1].prefix(1))
            initialsLabel.text = "\(firstNameLetter)\(lastNameLetter)"
        }
    }
    
    // MARK: - Private Methods
    
    private func handleTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        addGestureRecognizer(tap)
    }
    
    private func setupLayout() {        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        addSubview(photoImageView)
        addSubview(initialsLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),

            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            initialsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            initialsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            initialsLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])
    }
    
    @objc private func imageViewTapped(_: UITapGestureRecognizer) {
        delegate?.tappedProfileLogoImageView()
    }
}

// MARK: - ConfigurableView

extension ProfilePhotoView: ConfigurableView {
    func configure(with model: UserViewModel) {
        photoImageView.image = model.profileImage
        initialsLabel.isHidden = model.profileImage != nil
        setPlaceholderLetters(fullName: model.fullName)
    }
}
