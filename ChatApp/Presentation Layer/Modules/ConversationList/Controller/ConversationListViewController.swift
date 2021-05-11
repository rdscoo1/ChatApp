//
//  ConversationListViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/27/21.
//

import UIKit
import CoreData

class ConversationListViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationTableViewCell.self,
                           forCellReuseIdentifier: ConversationTableViewCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = tableViewDataSource
        tableView.dataSource = tableViewDataSource
        return tableView
    }()
    
    private let profileLogoImageView = ProfilePhotoView()
    
    private let createChannelButton = UIButton()
        
    private var settingsBarButton: UIBarButtonItem?
    var profileBarButton: UIBarButtonItem?

    // MARK: - Private Properties
    
    var channelsFBService: IChannelsFBService?
    
    var userDataManager: IUserDataManager?
    
    var presentationAssembly: IPresentationAssembly?
    
    var transitionDelegate: UIViewControllerTransitioningDelegate?
    
    var fetchedResultsController: NSFetchedResultsController<DBChannel>?
    
    private lazy var tableViewDataSource = ConversationListTableViewDataSourceDelegate(
        fetchedResultsController: fetchedResultsController!,
        channelsFBService: channelsFBService!,
        presentationAssembly: presentationAssembly!,
        navigationController: navigationController!)
    
    private lazy var frcDelegate: FRCDelegate = FRCDelegate(tableView: tableView)
    
    private var channels: [DBChannel]? {
        fetchedResultsController?.fetchedObjects
    }
    
    // MARK: - LifeCycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Themes.current.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.LocalizationKey.channels.string
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureNavBarButtons()
        setupLayout()
        setupTheme()
        loadUserData()
        loadChannels()
    }
    
    // MARK: - Private Methods
    
    private func loadChannels() {
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            showErrorAlert(message: error.localizedDescription)
        }
        
        fetchedResultsController?.delegate = frcDelegate
        
        channelsFBService?.subscribeOnChannels { (result) in
            if case Result.failure(let error) = result {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadUserData() {
        userDataManager?.loadProfile { [weak self] user in
            DispatchQueue.main.async {
                self?.profileLogoImageView.configure(with: user)
            }
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
        let alert = UIAlertController(title: Constants.LocalizationKey.createNewChannel.string, message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = Constants.LocalizationKey.enterChannelName.string
        }
        
        alert.addAction(UIAlertAction(title: Constants.LocalizationKey.cancel.string, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Constants.LocalizationKey.create.string, style: .default, handler: { [weak self] _ in
            if let name = alert.textFields?.first?.text,
               !name.isEmpty {
                self?.channelsFBService?.createChannel(withName: name) { (result) in
                    if case .failure = result {
                        self?.showErrorAlert(message: Constants.LocalizationKey.errorDuringChannelCreation.string)
                    }
                }
            } else {
                self?.showErrorAlert(message: Constants.LocalizationKey.errorChannelNameIsEmpty.string)
            }
        }))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: Constants.LocalizationKey.error.string, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.LocalizationKey.okay.string, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupTheme() {
        let theme = Themes.current
        tableView.backgroundColor = theme.colors.primaryBackground
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
        guard let themesViewController = presentationAssembly?.settingsViewController() else { return }
        
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
        
        profileBarButton = UIBarButtonItem(customView: rightBarButtonView)
        navigationItem.rightBarButtonItem = profileBarButton
    }
    
    @objc private func profileViewTapped() {
        guard let profile = userDataManager?.profile else { return }
        guard let profileViewController = presentationAssembly?.profileViewController(profileDataUpdatedHandler: { [weak self] in
            self?.loadUserData()
        }) else { return }
        profileViewController.user = profile
        
        guard let rootNavController = presentationAssembly?.rootNavigationViewController(profileViewController) else {
            return
        }
        
        rootNavController.transitioningDelegate = transitionDelegate
        rootNavController.modalPresentationStyle = .custom
        navigationController?.present(rootNavController, animated: true)
    }
    
    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.fetchedResultsController?.sections,
           indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }
}
