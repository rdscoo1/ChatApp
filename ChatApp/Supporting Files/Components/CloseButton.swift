//
//  CloseButton.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import UIKit

class CloseButton: UIButton {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = Themes.current.colors.navigationBar.closeButtonBackground
        setImage(.closeIcon, for: .normal)
        tintColor = Themes.current.colors.navigationBar.closeIconTint
    }
}
