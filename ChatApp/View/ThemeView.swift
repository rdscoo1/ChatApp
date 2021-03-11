//
//  ThemeView.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/9/21.
//

import UIKit

protocol ThemeViewDelegate: AnyObject {
    func themeSelected(_ view: ThemeView, withOption themeOption: ThemeOptions)
}

class ThemeView: UIView {

    // MARK: - Private Properties
        
    private(set) var themeOption: ThemeOptions = .classic
    
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
                containerView.layer.borderColor = Constants.Colors.themeViewIsSelected.cgColor
                containerView.layer.borderWidth = 3
            } else {
                containerView.layer.borderColor = Constants.Colors.themeViewNotSelected.cgColor
                containerView.layer.borderWidth = 1
            }
        }
    }
    
    // Handle tap
    
    /*
        Если не делать поле делегата weak, это может стать причиной memory leak,
        например ссылка на объект этого класса хранится в поле объекта делегата,
        а этот объект захватывает сильную ссылку на делегат.
    */
    weak var delegate: ThemeViewDelegate?
    
    // MARK: - Initializers
    
    init(themeOption: ThemeOptions) {
        super.init(frame: .zero)
        
        self.themeOption = themeOption
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
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let theme = themeOption.theme
        
        containerView.backgroundColor = theme.colors.primaryBackground
        
        incomingBubbleImageView.image = .incomingBubble
        outgoingBubbleImageView.image = .outgoingBubble
        
        incomingBubbleImageView.tintColor = theme.colors.conversation.cell.incoming.background
        outgoingBubbleImageView.tintColor = theme.colors.conversation.cell.outgoing.background
        
        themeTitle.text = theme.name
        themeTitle.textAlignment = .center
        themeTitle.textColor = theme.colors.themes.text
        stackView.axis = .vertical
        stackView.spacing = verticalSpacing
    
        [containerView, incomingBubbleImageView, outgoingBubbleImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(themeIsSelected)))
    }
    
    @objc private func themeIsSelected() {
        isSelected = true
        delegate?.themeSelected(self, withOption: themeOption)
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
