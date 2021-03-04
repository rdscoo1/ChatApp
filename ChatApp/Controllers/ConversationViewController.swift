//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/2/21.
//

import UIKit

class ConversationViewController: UIViewController {

    // MARK: - Public Properties
    
    var conversationTitle: String?
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageTableViewCell.self,
                           forCellReuseIdentifier: MessageTableViewCell.reuseId)
        tableView.estimatedRowHeight = 96
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.backgroundColor = Constants.Colors.appTheme
        return tableView
    }()
    
    private let dataProvider = DataProvider()
    private lazy var items: [MessageCellModel] = dataProvider.getMessages()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        title = conversationTitle
        view.backgroundColor = .white
        
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseId, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}
