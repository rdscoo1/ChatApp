//
//  TextViewDelegate.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/19/21.
//

import UIKit

class TextViewDelegate: NSObject {
    
    enum TextViewType {
        case nameTextView
        case descriptionTextView
    }
    
    // MARK: - Public properties
    
    var textViewType: TextViewType?
    
    let textChangedHandler: () -> Void
    
    // MARK: - Public properties
    
    private var limitCharNumber: Int? {
        switch textViewType {
        case .nameTextView:
            return 32
        case .descriptionTextView:
            return 64
        case .none:
            return nil
        }
    }
    
    private var limitNumberOfLines: Int? {
        switch textViewType {
        case .descriptionTextView:
            return 3
        default:
            return nil
        }
    }

    // MARK: - Initializer
    
    init(textViewType: TextViewType? = nil, textChangedHandler: @escaping () -> Void) {
        self.textChangedHandler = textChangedHandler
        self.textViewType = textViewType
    }
}

// MARK: - UITextViewDelegate

extension TextViewDelegate: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let textViewType = self.textViewType,
              let limitCharNumber = self.limitCharNumber else {
            return true
        }
        let currentText = textView.text ?? ""
        
        if text == "\n" {
            if textViewType == .nameTextView || currentText.hasSuffix("\n") {
                textView.resignFirstResponder()
                return false
            } else if textViewType == .descriptionTextView, let limitNumberOfLines = self.limitNumberOfLines {
                var numberOfLines = 0
                currentText.enumerateLines { (_, _) in
                    numberOfLines += 1
                }
                if numberOfLines >= limitNumberOfLines {
                    textView.resignFirstResponder()
                    return false
                }
            }
        }
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= limitCharNumber
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChangedHandler()
    }
}
