//
//  ThemeView.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/9/21.
//

import UIKit

protocol ThemeViewDelegate: AnyObject {
    func themeSelected()
}

class ThemeView: UIView {

    // MARK: - Private Properties
        
    private let containerView = UIView()
    private let incomingBubbleImageView = UIImageView()
    private let outgoingBubbleImageView = UIImageView()
    private let themeTitle = UILabel()
    private let stackView = UIStackView()
    
    // Constraints constants
    
    private let containerViewHeight: CGFloat = 60
    private let verticalSpacing: CGFloat = 20
    private let padding: CGFloat = 16
    private let bubbleHeight: CGFloat = 24
    private let bubbleWidthMultiplier: CGFloat = 0.36
 
    // MARK: - Public Properties
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                containerView.layer.borderColor = Constants.Colors.themeIsSelected.cgColor
                containerView.layer.borderWidth = 3
            } else {
                containerView.layer.borderColor = Constants.Colors.themeNotSelected.cgColor
                containerView.layer.borderWidth = 1
            }
        }
    }
    
    // Handle tap
    
    var didTapOnThemeView: (() -> Void)?
    weak var delegate: ThemeViewDelegate?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = 14
    }
    
    // MARK: - Public Methods
    
//    func configure() {
//        themeTitle.text =
//    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        containerView.backgroundColor = .white
        
        incomingBubbleImageView.image = UIImage(named: "incomingBubble")
        outgoingBubbleImageView.image = UIImage(named: "outgoingBubble")
        
        incomingBubbleImageView.tintColor = Constants.Colors.incomingBubbleClassic
        outgoingBubbleImageView.tintColor = Constants.Colors.outgoingBubbleClassic
        
        themeTitle.text = Constants.LocalizationKey.classic.string
        themeTitle.textAlignment = .center
        themeTitle.textColor = .white
        stackView.axis = .vertical
        stackView.spacing = verticalSpacing
    
        [containerView, incomingBubbleImageView, outgoingBubbleImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(themeIsSelected)))
    }
    
    @objc private func themeIsSelected() {
        print("Theme selected")
        isSelected = true
        delegate?.themeSelected()
    }
    
    private func setupLayout() {
        containerView.addSubview(incomingBubbleImageView)
        containerView.addSubview(outgoingBubbleImageView)
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(themeTitle)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: containerViewHeight),
            incomingBubbleImageView.heightAnchor.constraint(equalToConstant: bubbleHeight),
            incomingBubbleImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            incomingBubbleImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding * 2),
            
            outgoingBubbleImageView.heightAnchor.constraint(equalToConstant: bubbleHeight),
            outgoingBubbleImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            outgoingBubbleImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding * 2),
            outgoingBubbleImageView.leadingAnchor.constraint(equalTo: incomingBubbleImageView.trailingAnchor, constant: 18),
            outgoingBubbleImageView.widthAnchor.constraint(equalTo: incomingBubbleImageView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }

}
