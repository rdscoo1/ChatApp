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
    var channelId: String?
    
    // MARK: - Private Properties

    private var messages = [Message]()
    lazy var firestoreService = FirestoreService()

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
        //        tableView.backgroundColor = Constants.Colors.appTheme
        return tableView
    }()

    private let sendMessageView = SendMessageView()
    private lazy var sendMessageViewBottomConstraint = sendMessageView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor)

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = conversationTitle
        
        setupTheme()
        setupLayout()
        configureDismissKeyboard()
        subscribeOnMessagesUpdates()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        firestoreService.unsubscribe()
    }
    
    // MARK: - Private Methods

    private func subscribeOnMessagesUpdates() {
        guard let channelId = channelId else { return }
        firestoreService.fetchMessagesForChannel(withId: channelId) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.messages = messages
                    self?.tableView.reloadData()
                    self?.scrollToBottom()
                case .failure:
                    break
                }
            }
        }
    }

    private func setupTheme() {
        view.backgroundColor = Themes.current.colors.primaryBackground
    }
    
    private func setupLayout() {
        sendMessageView.delegate = self
        sendMessageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear

        view.addSubview(tableView)
        view.addSubview(sendMessageView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sendMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendMessageView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            sendMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendMessageViewBottomConstraint
        ])
    }

    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let row = messages.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: indexPath,
                              at: .bottom,
                              animated: true)
    }

    private func configureDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           keyboardSize.height > 0 {

            sendMessageViewBottomConstraint.constant = -keyboardSize.height + view.safeAreaInsets.bottom

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {

        sendMessageViewBottomConstraint.constant = 0

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(false)
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseId, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        let item = messages[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

// MARK: - SendMessageViewDelegate

extension ConversationViewController: SendMessageViewDelegate {

    func send(text: String) {
        DispatchQueue.main.async {
            self.resignFirstResponder()
        }
        firestoreService.sendMessage(content: text) { [weak self] result in
            DispatchQueue.main.async {
                if case Result.failure(_) = result {
                    let alert = UIAlertController(title: "Error",
                                                  message: "Error during adding new message, try later.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okey", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    self?.scrollToBottom()
                }
            }

        }
    }
}
