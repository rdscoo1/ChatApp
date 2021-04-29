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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 3
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Themes.current.colors.profile.saveButtonBackground
        clipsToBounds = true
        setTitleColor(Themes.current.colors.profile.buttonTitle, for: .normal)
        setTitleColor(UIColor.lightGray, for: .disabled)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = 1
        titleLabel?.lineBreakMode = .byClipping
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
}
