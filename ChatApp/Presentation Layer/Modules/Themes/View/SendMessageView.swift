//
//  SendMessageView.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/26/21.
//

import UIKit

protocol SendMessageViewDelegate: AnyObject {
    func send(text: String)
}

class SendMessageView: UIView {

    // MARK: - Public Properties

    weak var delegate: SendMessageViewDelegate?

    // MARK: - UI

    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 14)
        return textView
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setImage(.sendMessageIcon, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(sendMessageDidTap), for: .touchUpInside)
        return button
    }()

    private let padding: CGFloat = 8
    private let defaultTextViewHeight: CGFloat = 36
    private let maxTextViewHeight: CGFloat = 160
    private lazy var textViewHeightConstraint = inputTextView.heightAnchor.constraint(equalToConstant: defaultTextViewHeight)

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupLayout()
    }

    // MARK: - Lifecycle methods

    override func layoutSubviews() {
        super.layoutSubviews()

        inputTextView.layer.cornerRadius = 16
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 1
    }

    // MARK: - Private methods

    private func setupTheme() {
        let theme = Themes.current

        inputTextView.textColor = theme.colors.conversationList.cell.message
        inputTextView.backgroundColor = theme.colors.primaryBackground
        sendButton.tintColor = theme.colors.conversation.cell.outgoing.background
        backgroundColor = theme.colors.navigationBar.background
    }

    private func setupLayout() {
        addSubview(inputTextView)
        addSubview(sendButton)

        NSLayoutConstraint.activate([
            textViewHeightConstraint,
            inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            sendButton.leadingAnchor.constraint(equalTo: inputTextView.trailingAnchor, constant: padding),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor, multiplier: 1),
            sendButton.heightAnchor.constraint(equalToConstant: defaultTextViewHeight)
        ])
    }

    @objc private func sendMessageDidTap() {
        if let text = inputTextView.text {
            delegate?.send(text: text)
            inputTextView.text = nil
            textViewHeightConstraint.constant = defaultTextViewHeight
            sendButton.isEnabled = false
        }
    }
}

// MARK: - UITextViewDelegate

extension SendMessageView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = !(textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        let size = textView.sizeThatFits(.init(width: textView.bounds.width, height: maxTextViewHeight))
        if size.height > maxTextViewHeight {
            textViewHeightConstraint.constant = maxTextViewHeight
            textView.isScrollEnabled = true
        } else {
            textViewHeightConstraint.constant = size.height > defaultTextViewHeight ? size.height : defaultTextViewHeight
            textView.isScrollEnabled = false
        }
        textView.layoutIfNeeded()
    }
}
