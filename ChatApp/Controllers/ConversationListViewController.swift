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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = Constants.Colors.appTheme
        
        setupLayout()
        configureNavBarRightButton()
        configureNavBarLeftButton()
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavBarLeftButton() {
        let leftBarButton = UIBarButtonItem(image: .settingsIcon, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func configureNavBarRightButton() {
        let profileLogoImageView = ProfileLogoImageView()
        profileLogoImageView.setPlaceholderLetters(fullName: dataProvider.getMainUser().fullName)
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
}

// MARK: - UITableViewDelegate

extension ConversationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionName
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
}
