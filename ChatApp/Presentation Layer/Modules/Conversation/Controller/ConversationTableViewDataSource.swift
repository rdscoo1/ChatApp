//
//  ConversationTableViewDataSource.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/16/21.
//

import UIKit
import CoreData

class ConversationTableViewDataSource: NSObject, UITableViewDataSource {

    // MARK: - Private Property

    private var messages: [DBMessage]? {
        fetchedResultsController.fetchedObjects
    }

    // MARK: - Public Property

    var fetchedResultsController: NSFetchedResultsController<DBMessage>
    var messagesFBService: IMessagesService

    // MARK: - Init

    init(fetchedResultsController: NSFetchedResultsController<DBMessage>, messagesFBService: IMessagesService) {
        self.fetchedResultsController = fetchedResultsController
        self.messagesFBService = messagesFBService
    }

    // MARK: - Public Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseId, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }

        let message = fetchedResultsController.object(at: indexPath)
        cell.configure(with: message)

        return cell
    }
}
