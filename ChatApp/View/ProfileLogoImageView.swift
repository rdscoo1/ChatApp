//
//  ProfileLogoImageView.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit

protocol ProfileLogoImageViewDelegate: AnyObject {
    func tappedProfileLogoImageView()
}

class ProfileLogoImageView: UIView {
    
    // MARK: - Public properties
    
    var profileImage: UIImage? {
        logoImageView.image
    }
    
    // MARK: - Private Properties
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Constants.Colors.profileLogoBackground
        return imageView
    }()
    
    private lazy var initialsLabel: UILabel = {
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
    
    weak var delegate: ProfileLogoImageViewDelegate?
    
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
    
    func setLogo(image: UIImage?) {
        logoImageView.image = image
        initialsLabel.isHidden = true
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
        addSubview(logoImageView)
        addSubview(initialsLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),

            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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
