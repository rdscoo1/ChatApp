//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/2/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    static let reuseId = String(describing: self)
    
    // MARK: - Private Properties
    
    private let messageView = MessageBubbleView()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "An arbitrary text which we use to demonstrate how our label sizes' calculation works.An arbitrary text which we use to demonstrate how our label sizes' calculation worksAn arbitrary text which we use to demonstrate how our label sizes' calculation works"
        return label
    }()
    
    private let offset: CGFloat = 12
    private let widthMultiplier: CGFloat = 0.75
    
    // MARK: - Constraints
    
    private lazy var incomingMessageConstraint = messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
    private lazy var outgoingMessageConstraint = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
    private lazy var messageLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: offset)

    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Public Methods
    
    func configure(with model: MessageCellModel) {
        let themeColors = Themes.current.colors.conversation.cell
        let directionTheme = model.direction == .incoming ? themeColors.incoming : themeColors.outgoing
        messageLabel.textColor = directionTheme.text
        messageView.fillColor = directionTheme.background
        
        messageLabel.text = model.text
        
        if model.direction == .incoming {
            messageLeadingConstraint.constant = offset + 6
            messageView.type = .incoming
            outgoingMessageConstraint.isActive = false
            incomingMessageConstraint.isActive = true
        } else {
            messageLeadingConstraint.constant = offset
            messageView.type = .outgoing
            incomingMessageConstraint.isActive = false
            outgoingMessageConstraint.isActive = true
        }
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        backgroundColor = .clear
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        messageView.addSubview(messageLabel)
        contentView.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            messageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: widthMultiplier),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 8),
            messageLeadingConstraint,
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -offset),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8)
        ])
    }

}
