//
//  ConversationTableViewCell.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/1/21.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let reuseId = String(describing: self)
    
    // MARK: - UI

    private lazy var interlocutorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var messageDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let disclosureRight = UIImageView()

    // MARK: - Private Property

    private let offset: CGFloat = 8
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        messageLabel.numberOfLines = 2
        disclosureRight.image = .disclosureRight
        disclosureRight.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(disclosureRight)
        contentView.addSubview(interlocutorNameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(messageDateLabel)
        
        NSLayoutConstraint.activate([
            interlocutorNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset * 2),
            interlocutorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset * 2),
            interlocutorNameLabel.trailingAnchor.constraint(equalTo: messageDateLabel.leadingAnchor, constant: -offset),
            
            messageDateLabel.centerYAnchor.constraint(equalTo: interlocutorNameLabel.centerYAnchor),
            messageDateLabel.leadingAnchor.constraint(equalTo: interlocutorNameLabel.trailingAnchor, constant: offset),
            messageDateLabel.trailingAnchor.constraint(equalTo: disclosureRight.leadingAnchor, constant: -offset),
            
            disclosureRight.heightAnchor.constraint(equalToConstant: 10),
            disclosureRight.widthAnchor.constraint(equalToConstant: 7),
            disclosureRight.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset * 2),
            disclosureRight.leadingAnchor.constraint(equalTo: messageDateLabel.trailingAnchor, constant: offset),
            disclosureRight.centerYAnchor.constraint(equalTo: messageDateLabel.centerYAnchor, constant: -1),
            
            messageLabel.topAnchor.constraint(equalTo: interlocutorNameLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: interlocutorNameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset * 2)
        ])
    }
}

// MARK: - ConfigurableView

extension ConversationTableViewCell: ConfigurableView {
    func configure(with model: DBChannel) {
        backgroundColor = Themes.current.colors.conversationList.cell.background
        
        guard let name = model.name else {
            return
        }

        let theme = Themes.current

        interlocutorNameLabel.text = name

        if let message = model.lastMessage {
            if message.isEmpty {
                messageLabel.text = "No messages yet"
                messageLabel.font = .italicSystemFont(ofSize: 14)
                messageDateLabel.text = nil
            } else {
                messageLabel.text = message
            }
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 14)
            messageDateLabel.text = nil
        }

        if let lastActivityDate = model.lastActivity {
            if lastActivityDate.isDateInToday {
                messageDateLabel.text = model.lastActivity?.formatted(with: "HH:mm")
            } else {
                messageDateLabel.text = model.lastActivity?.formatted(with: "dd MMM")
            }
        } else {
            messageDateLabel.text = ""
        }

        interlocutorNameLabel.textColor = theme.colors.conversationList.cell.interlocutorName
        messageLabel.textColor = theme.colors.conversationList.cell.message
        messageDateLabel.textColor = theme.colors.conversationList.cell.receivedDate
        disclosureRight.tintColor = theme.colors.conversationList.cell.receivedDate

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = theme.colors.conversationList.cell.cellSelected
        self.selectedBackgroundView = selectedBackgroundView
    }
}
