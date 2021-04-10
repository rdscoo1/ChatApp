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
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let profileLogoImageView = ProfileLogoImageView()

    private let createChannelButton = UIButton()
    
    private var settingsBarButton: UIBarButtonItem?

    // MARK: - Private Properties

    private var channels: [DBChannel]? {
        fetchedResultsController.fetchedObjects
    }
    lazy var firestoreService = FirestoreService()

    private var user: UserViewModel? {
        didSet {
            if let user = self.user {
                DispatchQueue.main.async { [weak self] in
                    self?.profileLogoImageView.setPlaceholderLetters(fullName: user.fullName)
                }
            }
        }
    }

    private lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                               NSSortDescriptor(key: "lastActivity", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchBatchSize = 20

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: CoreDataService.shared.mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "channelsList")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    // MARK: - LifeCycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Themes.current.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            try fetchedResultsController.performFetch()
        } catch {
            showErrorAlert(message: error.localizedDescription)
            
        }

        firestoreService.subscribeOnChannels { (result) in
            if case Result.failure(let error) = result {
                print(error.localizedDescription)
            }
        }
    }

    func loadUserData() {
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
        let alert = UIAlertController(title: Constants.LocalizationKey.createNewChannel.string, message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = Constants.LocalizationKey.enterChannelName.string
        }

        alert.addAction(UIAlertAction(title: Constants.LocalizationKey.cancel.string, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Constants.LocalizationKey.create.string, style: .default, handler: { [weak self] _ in
            if let name = alert.textFields?.first?.text,
               !name.isEmpty {
                self?.firestoreService.createChannel(withName: name) { (result) in
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
            self?.loadUserData()
        }
        navigationController?.present(navController, animated: true)
    }

    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.fetchedResultsController.sections,
           indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }
}

// MARK: - UITableViewDataSource

extension ConversationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseId, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }

        if self.validateIndexPath(indexPath) {
            let channel = fetchedResultsController.object(at: indexPath)
            cell.configure(with: channel)

        } else {
            print("Attempting to configure a cell for an indexPath that is out of bounds: \(indexPath)")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
           let identifier = channels?[indexPath.row].identifier {
            firestoreService.removeChannel(withId: identifier)
        }
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
        let conversationVC = ConversationViewController()

        let channel = fetchedResultsController.object(at: indexPath)
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

// MARK: - NSFetchedResultsControllerDelegate Conformance

extension ConversationListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .top)
                tableView.insertRows(at: [newIndexPath], with: .top)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        @unknown default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
