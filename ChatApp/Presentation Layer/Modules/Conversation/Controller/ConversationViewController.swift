//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/2/21.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {

    // MARK: - Public Properties
    
    var conversationTitle: String?
    var channelId: String?
    
    // MARK: - Private Properties

    private var messages: [DBMessage]? {
        fetchedResultsController?.fetchedObjects
    }

    var messageService: IMessagesService?

    var fetchedResultsController: NSFetchedResultsController<DBMessage>?

    private lazy var frcDelegate: FRCDelegate = FRCDelegate(tableView: tableView)

    private lazy var tableViewDataSource = ConversationTableViewDataSource(fetchedResultsController: fetchedResultsController!,
                                                                           messagesFBService: messageService!)
    
    private lazy var sendMessageViewBottomConstraint = sendMessageView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor)

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageTableViewCell.self,
                           forCellReuseIdentifier: MessageTableViewCell.reuseId)
        tableView.estimatedRowHeight = 96
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = tableViewDataSource
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        // Revert tableView to scroll chat from bottom to top
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return tableView
    }()

    private let sendMessageView = SendMessageView()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = conversationTitle
        
        setupTheme()
        setupLayout()
        configureDismissKeyboard()
        loadMessages()
    }
    
    // MARK: - Private Methods

    private func loadMessages() {
        guard let channelId = channelId else { return }

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }

        fetchedResultsController?.delegate = frcDelegate

        messageService?.subscribeOnMessagesFromChannel(withId: channelId) { (result) in
            if case Result.failure(let error) = result {
                print(error.localizedDescription)
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

// MARK: - SendMessageViewDelegate

extension ConversationViewController: SendMessageViewDelegate {
    func send(text: String) {
        DispatchQueue.main.async {
            self.resignFirstResponder()
        }
        messageService?.sendMessage(content: text) { [weak self] result in
            DispatchQueue.main.async {
                if case .failure = result {
                    let alert = UIAlertController(title: Constants.LocalizationKey.error.string,
                                                  message: Constants.LocalizationKey.errorDuringSendingMessage.string,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Constants.LocalizationKey.okay.string, style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
