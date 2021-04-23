//
//  AlertService.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import UIKit

class AlertService {
    func presentAlert(vc: UIViewController?,
                      title: String,
                      message: String,
                      additionalActions: [UIAlertAction] = [],
                      primaryHandler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "OK", style: .cancel, handler: primaryHandler))
            additionalActions.forEach { alertController.addAction($0) }
            vc?.present(alertController, animated: true)
        }
    }
    
    func presentErrorAlert(vc: UIViewController?,
                           message: String = Constants.LocalizationKey.actionNotAllowed.string,
                           handler: ((UIAlertAction) -> Void)? = nil) {
        presentAlert(vc: vc, title: Constants.LocalizationKey.error.string, message: message, primaryHandler: handler)
    }
}
