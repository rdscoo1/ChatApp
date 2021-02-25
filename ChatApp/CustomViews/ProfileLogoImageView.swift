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

class ProfileLogoImageView: UIImageView {
    
    // MARK: - Private Properties
    
    private lazy var nameFirstLetterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 120, weight: .regular)
        return label
    }()
    
    private lazy var surnameFirstLetterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 120, weight: .regular)
        return label
    }()
    
    weak var delegate: ProfileLogoImageViewDelegate?
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setupImageView()
        handleTap()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
        handleTap()
        configureConstraints()
    }
    
    // Touch only inside bounds of rounded view
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let circlePath = UIBezierPath(ovalIn: self.bounds)
        return circlePath.contains(point)
    }

    // MARK: - Public Methods
    
    func hidePlaceholderLetters() {
        guard self.image == nil else {
            nameFirstLetterLabel.alpha = 0.0
            surnameFirstLetterLabel.alpha = 0.0
            return
        }
        
        nameFirstLetterLabel.alpha = 1.0
        surnameFirstLetterLabel.alpha = 1.0
    }
    
    func setPlaceholderLetters(name: String?) {
        guard let name = name else { return }
                
        let wordsArr = name.components(separatedBy: " ")
        let firstNameLetter = String(wordsArr[0].prefix(1))
        let lastNameLetter = String(wordsArr[1].prefix(1))
        
        nameFirstLetterLabel.text = firstNameLetter
        surnameFirstLetterLabel.text = lastNameLetter
    }
    
    // MARK: - Private Methods
    
    private func setupImageView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 120
        clipsToBounds = true
        backgroundColor = Constants.Colors.profileLogoBackground
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
    }
    
    private func handleTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        addGestureRecognizer(tap)
    }
    
    private func configureConstraints() {
        addSubview(nameFirstLetterLabel)
        addSubview(surnameFirstLetterLabel)
        
        NSLayoutConstraint.activate([
            nameFirstLetterLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -26),
            nameFirstLetterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            surnameFirstLetterLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 38),
            surnameFirstLetterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func imageViewTapped(_: UITapGestureRecognizer) {
        delegate?.tappedProfileLogoImageView()
    }
    
}
