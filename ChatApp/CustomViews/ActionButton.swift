//
//  ActionButton.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit

class ActionButton: UIButton {

    // MARK: - Initializers
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    
    // MARK: - Private Methods
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = self.frame.height / 3
        clipsToBounds = true
        setTitleColor(Constants.Colors.buttonText, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        backgroundColor = Constants.Colors.buttonBackground
    }
}
