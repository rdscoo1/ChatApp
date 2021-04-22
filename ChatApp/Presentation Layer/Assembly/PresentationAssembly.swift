//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/16/21.
//

import UIKit

protocol IPresentationAssembly {
    func rootNavigationViewController(_ rootViewController: UIViewController) -> RootNavigationController

    func conversationListViewController() -> ConversationListViewController

    func conversationViewController(channelId: String) -> ConversationViewController

    func profileViewController(profileDataUpdatedHandler: @escaping () -> Void) -> ProfileViewController

    func settingsViewController() -> ThemesViewController
}

class PresentationAssembly: IPresentationAssembly {

    let serviceAssembly: IServicesAssembly

    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }

    func rootNavigationViewController(_ rootViewController: UIViewController) -> RootNavigationController {
        return RootNavigationController(rootViewController: rootViewController)
    }

    func conversationListViewController() -> ConversationListViewController {
        let conversationsListViewController = ConversationListViewController()
        conversationsListViewController.presentationAssembly = self
        conversationsListViewController.userDataManager = serviceAssembly.userDataManager
        conversationsListViewController.channelsFBService = serviceAssembly.channelsFBService()
        conversationsListViewController.fetchedResultsController = serviceAssembly.channelsFetchedResultsController()
        return conversationsListViewController
    }

    func conversationViewController(channelId: String) -> ConversationViewController {
        let conversationViewController = ConversationViewController()
        conversationViewController.channelId = channelId
        conversationViewController.messageService = serviceAssembly.messagesFBService(channelId: channelId)
        conversationViewController.fetchedResultsController = serviceAssembly.messagesFetchedResultsController(channelId: channelId)
        return conversationViewController
    }

    func profileViewController(profileDataUpdatedHandler: @escaping () -> Void) -> ProfileViewController {
        let profileViewController = ProfileViewController()
        profileViewController.profileDataUpdatedHandler = profileDataUpdatedHandler
        profileViewController.userDataManager = serviceAssembly.userDataManager
        return profileViewController
    }

    func settingsViewController() -> ThemesViewController {
        let themesViewController = ThemesViewController()
        return themesViewController
    }
}
