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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let createChannelButton = UIButton()
    
    private var settingsBarButton: UIBarButtonItem?

    private var channels = [Channel]()
    lazy var firestoreService = FirestoreService()

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
        loadChannels()
    }
    
    // MARK: - Private Methods

    private func loadChannels() {
        firestoreService.subscribeOnChannels { [weak self] (result) in
            switch result {
            case .success(let channels):
                DispatchQueue.main.async {
                    self?.channels = channels
                    self?.tableView.reloadData()
                }
            case .failure(let error):
               print("Error during update channels: \(error.localizedDescription)")
            }
        }
    }

    func loadData() {
        let dataManager = OperationAsyncManager()
        
        dataManager.loadUserData { [weak self] user in
            self?.user = user
        }
    }
    
    private func setupLayout() {
        createChannelButton.translatesAutoresizingMaskIntoConstraints = false
        createChannelButton.layer.cornerRadius = 32
        createChannelButton.layer.masksToBounds = true
        createChannelButton.backgroundColor = Constants.Colors.outgoingBubbleBackgroundDay
        let startChannelIconImage = UIImage.startChannelIcon.tinted(color: .white)
        createChannelButton.setImage(startChannelIconImage, for: .normal)
        createChannelButton.addTarget(self, action: #selector(createChannelButtonDidTap), for: .touchUpInside)

        view.addSubview(tableView)
        view.addSubview(createChannelButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            createChannelButton.heightAnchor.constraint(equalToConstant: 64),
            createChannelButton.widthAnchor.constraint(equalToConstant: 64),
            createChannelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            createChannelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    @objc private func createChannelButtonDidTap() {
        let alert = UIAlertController(title: "Create new channel", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Enter channel name here..."
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            if let name = alert.textFields?.first?.text,
               !name.isEmpty {
                self?.firestoreService.createChannel(withName: name) { (result) in
                    if case Result.failure(_) = result {
                        self?.showErrorAlert(message: "Error occurred during creating new channel, try later.")
                    }
                }
            } else {
                self?.showErrorAlert(message: "Channel name can't be empty.")
            }
        }))
        present(alert, animated: true)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error occurred", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupTheme() {
        let theme = Themes.current
        tableView.backgroundColor = theme.colors.navigationBar.background
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: theme.colors.navigationBar.title]
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseId, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }

        let channel = channels[indexPath.row]
        cell.configure(with: channel)
        
        return cell
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
            cell.contentView.backgroundColor = .clear
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else {
            return
        }
        
        let conversationVC = ConversationViewController()
        let channel = channels[selectedIndex.row]
        conversationVC.conversationTitle = channel.name
        conversationVC.channelId = channel.identifier

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
