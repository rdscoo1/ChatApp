//
//  ViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/18/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        Logger.defineState(of: .viewController,
                           oldState: Constants.ViewControllerState.loading.rawValue,
                           newState: Constants.ViewControllerState.loaded.rawValue,
                           method: #function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.defineState(of: .viewController,
                           oldState: Constants.ViewControllerState.loaded.rawValue,
                           newState: Constants.ViewControllerState.appearing.rawValue,
                           method: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.defineState(of: .viewController,
                           oldState: Constants.ViewControllerState.appearing.rawValue,
                           newState: Constants.ViewControllerState.appeared.rawValue,
                           method: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ViewController \(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("ViewController \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.defineState(of: .viewController,
                           oldState: Constants.ViewControllerState.appeared.rawValue,
                           newState: Constants.ViewControllerState.disappearing.rawValue,
                           method: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.defineState(of: .viewController,
                           oldState: Constants.ViewControllerState.disappearing.rawValue,
                           newState: Constants.ViewControllerState.disappeared.rawValue,
                           method: #function)
    }
}
