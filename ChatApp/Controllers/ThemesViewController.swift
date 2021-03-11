//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/9/21.
//

import UIKit

protocol ThemesPickerDelegate: class {
    func themeDidChange(on themeOption: ThemeOptions)
}

class ThemesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    let initialThemeOption = Themes.currentThemeOption
    
    private let stackView = UIStackView()
    
    // MARK: - Public Properties
    
    /*
     Если не делать поле делегата weak, это может стать причиной memory leak,
     например ссылка на объект этого класса хранится в поле объекта делегата,
     а этот объект захватывает сильную ссылку на делегат.
     */
    weak var delegate: ThemesPickerDelegate?
    
    /*
     Здесь возможна утечка если в замыкании будут сильные ссылки на объекты,
     имеющие сильные ссылки на объект этого класса (или ссылающиеся через цепочку сильных ссылок через другие объекты)
     Для предотвращения утечек памяти, необходимо использовать список захвата замыкания со слабыми ссылками
     */
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
        
        delegate?.themeDidChange(on: themeOption)
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
