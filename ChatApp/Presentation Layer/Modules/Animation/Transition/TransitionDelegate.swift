//
//  TransitionDelegate.swift
//  ChatApp
//
//  Created by Roman Khodukin on 30.04.2021.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransitioningAnimation(type: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransitioningAnimation(type: .dismiss)
    }
}
