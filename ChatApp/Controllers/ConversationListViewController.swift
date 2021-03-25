//
//  ConversationListViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/27/21.
//

import UIKit

class ConversationListViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationTableViewCell.self,
                           forCellReuseIdentifier: ConversationTableViewCell.reuseId)
        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var settingsBarButton: UIBarButtonItem?
    
    private let dataProvider = DataProvider()
    private lazy var items: [ConversationCellModel] = dataProvider.getConversations()
    
    private lazy var sections = [
        ConversationListSectionModel(sectionName: "Online", backgroundColor: UIColor.yellow.withAlphaComponent(0.5), items: items
                                        .filter { $0.isOnline }
                                        .sorted(by: { ($0.date ?? Date(timeIntervalSince1970: 0) > $1.date ?? Date(timeIntervalSince1970: 0))  })),
        ConversationListSectionModel(sectionName: "History", backgroundColor: nil, items: items
                                        .filter { $0.isOnline == false && $0.message != "" }
                                        .sorted(by: { ($0.date ?? Date(timeIntervalSince1970: 0) > $1.date ?? Date(timeIntervalSince1970: 0))  }))
    ]
    
    private let profileLogoImageView = ProfileLogoImageView()
    
    private var user: UserViewModel? {
        didSet {
            if let user = self.user {
                DispatchQueue.main.async { [weak self] in
                    self?.profileLogoImageView.setPlaceholderLetters(fullName: user.fullName)
                }
            }
        }
    }
    
    
    // MARK: - LifeCycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Themes.current.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = true
                
        loadData()
        setupLayout()
        configureNavBarButtons()
        setupTheme()
    }
    
    // MARK: - Private Methods
    
    func loadData() {
        let dataManager = OperationDataManager()
        
        dataManager.loadUserData { [weak self] user in
            self?.user = user
        }
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTheme() {
        let theme = Themes.current
        tableView.backgroundColor = theme.colors.navigationBar.background
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor:theme.colors.navigationBar.title]
            navBarAppearance.backgroundColor = theme.colors.navigationBar.background
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = theme.colors.navigationBar.background
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
        }
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
        tableView.separatorColor = Themes.current.colors.conversationList.table.separator
        settingsBarButton?.tintColor = theme.colors.navigationBar.tint
    }
    
    @objc private func goToThemesTapped() {
        let themesViewController = ThemesViewController()
        
        themesViewController.delegate = self
        
        themesViewController.didTapOnThemeView = { [weak self] themeOption in
            Themes.saveApplicationTheme(themeOption)
            self?.setupTheme()
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    private func configureNavBarButtons() {
        settingsBarButton = UIBarButtonItem(image: .settingsIcon, style: .plain, target: self, action: #selector(goToThemesTapped))
        settingsBarButton?.tintColor = Themes.current.colors.navigationBar.tint
        navigationItem.leftBarButtonItem = settingsBarButton
        
//        profileLogoImageView.setPlaceholderLetters(fullName: "Roman Khodukin")
        profileLogoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileViewTapped)))
        
        let rightBarButtonView = UIView()
        rightBarButtonView.addSubview(profileLogoImageView)
        profileLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            profileLogoImageView.leadingAnchor.constraint(equalTo: rightBarButtonView.leadingAnchor),
            profileLogoImageView.topAnchor.constraint(equalTo: rightBarButtonView.topAnchor),
            profileLogoImageView.trailingAnchor.constraint(equalTo: rightBarButtonView.trailingAnchor),
            profileLogoImageView.bottomAnchor.constraint(equalTo: rightBarButtonView.bottomAnchor, constant: -4)
        ])
        
        let rightBarButton = UIBarButtonItem(customView: rightBarButtonView)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func profileViewTapped() {
        let profileViewController = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileViewController)
        profileViewController.profileDataUpdatedHandler = { [weak self] in
            self?.loadData()
        }
        navigationController?.present(navController, animated: true)
    }
    
}


// MARK: - UITableViewDataSource

extension ConversationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseId, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionName
    }
    
}


// MARK: - UITableViewDelegate

extension ConversationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = Themes.current.colors.conversationList.cell.cellSelected
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = sections[indexPath.section].items[indexPath.row]
            cell.contentView.backgroundColor = item.isOnline ? Themes.current.colors.conversationList.cell.background : .clear
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else {
            return
        }
        
        let conversationVC = ConversationViewController()
        conversationVC.conversationTitle = sections[selectedIndex.section].items[selectedIndex.row].name
        navigationController?.pushViewController(conversationVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = Themes.current.colors.conversationList.table.sectionHeaderBackground
        headerView.textLabel?.textColor = Themes.current.colors.conversationList.table.sectionHeaderTitle
        
    }
    
}


// MARK: - ThemesPickerDelegate Conformance

extension ConversationListViewController: ThemesPickerDelegate {
    
    func themeDidChange(on themeOption: ThemeOptions) {
        //        Themes.saveApplicationTheme(themeOption)
        //        setupTheme()
        //        tableView.reloadData()
    }
    
}
