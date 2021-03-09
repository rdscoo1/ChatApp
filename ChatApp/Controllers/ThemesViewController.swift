//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/9/21.
//

import UIKit

class ThemesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let themePickerView = ThemeView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = Constants.LocalizationKey.settings.string
        view.backgroundColor = Constants.Colors.themesBackground
        
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        themePickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themePickerView)
        
        NSLayoutConstraint.activate([
            themePickerView.heightAnchor.constraint(equalToConstant: 100),
            themePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            themePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            themePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38)
        ])
    }

}
