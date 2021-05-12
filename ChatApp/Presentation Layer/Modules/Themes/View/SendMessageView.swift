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
        textView.backgroundColor = Themes.current.colors.conversation.sendMessage.background
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 14)
        textView.text = Constants.LocalizationKey.message.string
        textView.textColor = UIColor.lightGray
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
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

        inputTextView.layer.cornerRadius = 18
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
            inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding * 2),
            inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            sendButton.leadingAnchor.constraint(equalTo: inputTextView.trailingAnchor, constant: padding * 2),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding * 2),
            sendButton.centerYAnchor.constraint(equalTo: inputTextView.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 32)
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
            // create the updated text string
            let currentText: String = textView.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

            // If updated text view will be empty, add the placeholder
            // and set the cursor to the beginning of the text view
            if updatedText.isEmpty {

                textView.text = Constants.LocalizationKey.message.string
                textView.textColor = UIColor.lightGray

                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }

            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
             else if textView.textColor == UIColor.lightGray && !text.isEmpty {
                textView.textColor = Themes.current.colors.conversation.sendMessage.text
                textView.text = text
            }

            // For every other case, the text should change with the usual
            // behavior...
            else {
                return true
            }

            // ...otherwise return false since the updates have already
            // been made
            return false
    }
    
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
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
