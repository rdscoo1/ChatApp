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

    private lazy var senderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = """
        An arbitrary text which we use to demonstrate how our label sizes'\
        calculation works.An arbitrary text which we use to demonstrate how our label sizes'\
        calculation worksAn arbitrary text which we use to demonstrate how our label sizes'\
        calculation works
        """
        return label
    }()
    
    private let offset: CGFloat = 12
    private let widthMultiplier: CGFloat = 0.75
    
    // MARK: - Constraints
    
    private lazy var incomingMessageConstraint = messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
    private lazy var outgoingMessageConstraint = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
    private lazy var messageLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: offset)
    private lazy var messageLabelTopOutgoingConstraint = messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: offset)
    private lazy var messageLabelTopIncomingConstraint = messageLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: offset / 2)
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with model: DBMessage) {
        let themeColors = Themes.current.colors.conversation.cell
        let directionTheme = model.isMyMessage ? themeColors.outgoing : themeColors.incoming
        messageLabel.textColor = directionTheme.text
        messageView.fillColor = directionTheme.background
        senderNameLabel.textColor = directionTheme.text
        
        messageLabel.text = model.content
        
        if !model.isMyMessage {
            messageLeadingConstraint.constant = offset + 6
            messageView.type = .incoming
            senderNameLabel.text = model.senderName

            outgoingMessageConstraint.isActive = false
            incomingMessageConstraint.isActive = true
            messageLabelTopOutgoingConstraint.isActive = false
            messageLabelTopIncomingConstraint.isActive = true
        } else {
            messageLeadingConstraint.constant = offset
            messageView.type = .outgoing
            senderNameLabel.text = nil

            incomingMessageConstraint.isActive = false
            outgoingMessageConstraint.isActive = true
            messageLabelTopIncomingConstraint.isActive = false
            messageLabelTopOutgoingConstraint.isActive = true
        }
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        backgroundColor = .clear
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

        messageView.addSubview(senderNameLabel)
        messageView.addSubview(messageLabel)
        contentView.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            messageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: widthMultiplier),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            senderNameLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: offset),
            senderNameLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: offset + 6),
            senderNameLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -offset),

            messageLeadingConstraint,
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -offset),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -offset + 4)
        ])
    }
    
}
