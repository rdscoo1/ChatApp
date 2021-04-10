//
//  RootNavigationViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/12/21.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return viewControllers.first
    }
}
