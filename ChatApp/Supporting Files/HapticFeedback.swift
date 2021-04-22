//
//  HapticFeedback.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit

enum HapticFeedback {
    
    case success
    case warning
    case error
    case none
    
    // MARK: - Run vibro-haptic

    func impact() {
        let generator = UINotificationFeedbackGenerator()
        switch self {
        case .success:
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        case .warning:
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning)
        case .error:
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
        case .none:
            break
        }
    }
}
