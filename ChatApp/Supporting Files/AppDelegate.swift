//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/18/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    private var rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Themes.loadApplicationTheme()
        CoreDataManager.shared.printApplicationDocumentsDirectory()
        FirebaseApp.configure()

        window = AnimatedUIWindow()
        let conversationListViewController = rootAssembly.presentationAssembly.conversationListViewController()
        let rootNavigationController = rootAssembly.presentationAssembly.rootNavigationViewController(conversationListViewController)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        return true
    }
    
    private func createChatNavigationController() -> UINavigationController {
        let conversationViewController = ConversationListViewController()
        conversationViewController.title = Constants.LocalizationKey.channels.string
        conversationViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ProfilePhotoView())
        
        let navController = RootNavigationController(rootViewController: conversationViewController)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
