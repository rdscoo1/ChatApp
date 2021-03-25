//
//  ConversationTableViewCell.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/1/21.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let reuseId = String(describing: self)
    
    // MARK: - Private Properties
    
    private let interlocutorPhotoImageView = ProfileLogoImageView()
    
    private lazy var interlocutorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
//        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
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
        
        interlocutorPhotoImageView.setLogo(image: nil)
        interlocutorPhotoImageView.setPlaceholderLetters(fullName: nil)
        backgroundColor = nil
        messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    // MARK: - Public Methods
    
    func configure(with model: ConversationCellModel) {
        let theme = Themes.current
        
        if model.photo == nil {
            interlocutorPhotoImageView.setPlaceholderLetters(fullName: model.name)
        } else {
            interlocutorPhotoImageView.setLogo(image: model.photo!)
        }
            
        interlocutorNameLabel.text = model.name
        
        if let date = model.date,
           let message = model.message {
                    
            if model.hasUnreadMessages {
                messageLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            }
            
            if message.isEmpty {
                messageLabel.text = "No messages yet"
                messageLabel.font = .italicSystemFont(ofSize: 14)
                messageDateLabel.text = nil
            } else {
                messageLabel.text = model.message
            }
            
            if date.isDateInToday {
                messageDateLabel.text = model.date?.formatted(with: "HH:mm")
            } else {
                messageDateLabel.text = model.date?.formatted(with: "dd MMM")
            }
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 14)
            messageDateLabel.text = nil
        }
        
        contentView.backgroundColor = model.isOnline ? theme.colors.conversationList.cell.background : .clear
        
        interlocutorNameLabel.textColor = theme.colors.conversationList.cell.interlocutorName
        messageLabel.textColor = theme.colors.conversationList.cell.message
        messageDateLabel.textColor = theme.colors.conversationList.cell.receivedDate
        disclosureRight.tintColor = theme.colors.conversationList.cell.receivedDate
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = theme.colors.conversationList.cell.cellSelected
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        disclosureRight.image = .disclosureRight
        disclosureRight.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(disclosureRight)
        contentView.addSubview(interlocutorPhotoImageView)
        contentView.addSubview(interlocutorNameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(messageDateLabel)
        
        NSLayoutConstraint.activate([
            interlocutorPhotoImageView.heightAnchor.constraint(equalToConstant: 60),
            interlocutorPhotoImageView.widthAnchor.constraint(equalToConstant: 60),
            interlocutorPhotoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            interlocutorPhotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset * 2),
            
            interlocutorNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            interlocutorNameLabel.leadingAnchor.constraint(equalTo: interlocutorPhotoImageView.trailingAnchor, constant: offset),
            interlocutorNameLabel.trailingAnchor.constraint(equalTo: messageDateLabel.leadingAnchor, constant: -offset),
            
            messageDateLabel.centerYAnchor.constraint(equalTo: interlocutorNameLabel.centerYAnchor),
            messageDateLabel.leadingAnchor.constraint(equalTo: interlocutorNameLabel.trailingAnchor, constant: offset),
            messageDateLabel.trailingAnchor.constraint(equalTo: disclosureRight.leadingAnchor, constant: -offset),
            
            disclosureRight.heightAnchor.constraint(equalToConstant: 10),
            disclosureRight.widthAnchor.constraint(equalToConstant: 7),
            disclosureRight.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset * 2),
            disclosureRight.leadingAnchor.constraint(equalTo: messageDateLabel.trailingAnchor, constant: offset),
            disclosureRight.centerYAnchor.constraint(equalTo: messageDateLabel.centerYAnchor, constant: -1),
            
            messageLabel.topAnchor.constraint(equalTo: interlocutorNameLabel.bottomAnchor, constant: 2),
            messageLabel.leadingAnchor.constraint(equalTo: interlocutorNameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
        ])
    }
}
