//
//  ConversationListTableViewDataSourceDelegate.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/16/21.
//

import UIKit
import CoreData

class ConversationListTableViewDataSourceDelegate: NSObject, UITableViewDataSource {

    // MARK: - Private Property

    private var channels: [DBChannel]? {
        fetchedResultsController.fetchedObjects
    }

    // MARK: - Public Properties

    var navigationController: UINavigationController
    var presentationAssembly: IPresentationAssembly
    var fetchedResultsController: NSFetchedResultsController<DBChannel>
    var channelsFBService: IChannelsFBService

    // MARK: - Init

    init(fetchedResultsController: NSFetchedResultsController<DBChannel>,
         channelsFBService: IChannelsFBService,
         presentationAssembly: IPresentationAssembly,
         navigationController: UINavigationController) {
        self.fetchedResultsController = fetchedResultsController
        self.channelsFBService = channelsFBService
        self.presentationAssembly = presentationAssembly
        self.navigationController = navigationController
    }

    // MARK: - Private Methods

    private func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.fetchedResultsController.sections,
           indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }

    // MARK: - Public Methods

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
            channelsFBService.removeChannel(withId: identifier)
        }
    }
}

// MARK: - UITableViewDelegate

extension ConversationListTableViewDataSourceDelegate: UITableViewDelegate {

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
        let channel = fetchedResultsController.object(at: indexPath)

        guard let identifier = channel.identifier else {
            return
        }

        let conversationVC = presentationAssembly.conversationViewController(channelId: identifier)
        conversationVC.conversationTitle = channel.name
        navigationController.pushViewController(conversationVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = Themes.current.colors.conversationList.table.sectionHeaderBackground
        headerView.textLabel?.textColor = Themes.current.colors.conversationList.table.sectionHeaderTitle
    }
}
