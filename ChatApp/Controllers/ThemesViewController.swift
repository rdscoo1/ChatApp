//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/9/21.
//

import UIKit

class ThemesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    let initialThemeOption = Themes.currentThemeOption
    
    private let stackView = UIStackView()
    
    // MARK: - Public Properties

    var didTapOnThemeView: ((ThemeOptions) -> Void)?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = Constants.LocalizationKey.settings.string
        view.backgroundColor = Themes.current.colors.themes.background
        
        setupLayout()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let currentThemeOption = Themes.currentThemeOption
        
        ThemeOptions.allCases.forEach {
            let themePickerView = ThemeView(themeOption: $0)
            themePickerView.delegate = self
            themePickerView.isSelected = $0 == currentThemeOption
            stackView.addArrangedSubview(themePickerView)
        }
    }
    
    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func selectTheme(option themeOption: ThemeOptions) {
        stackView.arrangedSubviews
            .compactMap { $0 as? ThemeView }
            .filter { $0 !== view }
            .forEach { $0.isSelected = $0.themeOption == themeOption }
        
        didTapOnThemeView?(themeOption)
        updateTheme()
        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
    }
    
    private func updateTheme() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = Themes.current.colors.themes.background
        }
    }
    
}

extension ThemesViewController: ThemeViewDelegate {
    
    func themeSelected(_ view: ThemeView, withOption themeOption: ThemeOptions) {
        selectTheme(option: themeOption)
    }
    
}
