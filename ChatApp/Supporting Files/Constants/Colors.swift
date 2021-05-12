//
//  Colors.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/23/21.
//

import UIKit

extension Constants {
    enum Colors {        
        static var appTheme: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#19191B") :
                        UIColor(hex: "#FFFFFF")
                }
            } else {
                return UIColor(hex: "#FFFFFF")
            }
        }
        
        static var alertText: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#FFFFFF") :
                        UIColor(hex: "#001424")
                }
            } else {
                return UIColor(hex: "#001424")
            }
        }
        
        // MARK: - Profile ViewController
        
//        static var buttonBackground: UIColor {
//            if #available(iOS 13.0, *) {
//                return UIColor { (traits) -> UIColor in
//                    return traits.userInterfaceStyle == .dark ?
//                        UIColor(hex: "#FFFFFF", alpha: 0.2) :
//                        UIColor(hex: "#F6F6F6")
//                }
//            } else {
//                return UIColor(hex: "#F6F6F6")
//            }
//        }
//
        static var buttonText: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#FFFFFF") :
                        UIColor(hex: "#007AFF")
                }
            } else {
                return UIColor(hex: "#007AFF")
            }
        }
        
        static var profileLogoBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#E4E82B", alpha: 0.5) :
                        UIColor(hex: "#E4E82B")
                }
            } else {
                return UIColor(hex: "#E4E82B")
            }
        }
        
        // MARK: - Message bubbles
        
        static let outgoingMessageBubble = UIColor(hex: "#2A87FF")
        
        static var incomingMessageBubble: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#19191B") :
                        UIColor(hex: "#E9E9EB")
                }
            } else {
                return UIColor(hex: "#E9E9EB")
            }
        }
        
        static var incomingMessageText: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        .white :
                        .black
                }
            } else {
                return .black
            }
        }
        
        // MARK: - App Theme basic
        
        static let blue = UIColor(hex: "#0584FE")
        
        static let settingsIconGray = UIColor(hex: "#545458")
        static let buttonTitleLight = UIColor.black
        static let buttonTitleDark = UIColor.white
        
        static let closeButtonLightBackground = UIColor(red: 0.51, green: 0.55, blue: 0.60, alpha: 0.12)
        static let closeButtonDarkBackground = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.20)
        static let closeIconLightTint = UIColor(hex: "#818C99")
        static let closeIconDarkTint = UIColor.white
        
        static let navigationBarBackgroundNight = UIColor(hex: "#1E1E1E")
        static let primaryNightBackground = UIColor(hex: "#1E1E1E")
        
        static let titleTextLight = UIColor.black
        static let titleTextDark = UIColor.white
        static let subtitleTextLight = UIColor(hex: "#3C3C43")
        static let subtitleTextDark = UIColor(hex: "#8D8D93")
        
        static let yellowLight = UIColor(hex: "#FEFCD8")
        static let yellowDark = UIColor(hex: "#191709")
        
        static let lightGray = UIColor(hex: "#F6F6F6")
        static let darkGray = UIColor(hex: "#1E1E1E")
        
        static let themeViewIsSelected = UIColor(hex: "#007AFF")
        static let themeViewNotSelected = UIColor(hex: "#979797")
        
        static let themesVCBackground = UIColor(hex: "#193661")
        
        // MARK: - Conversation
        
        static let incomingBubbleBackgroundClassic = UIColor(hex: "#DFDFDF")
        static let outgoingBubbleBackgroundClassic = UIColor(hex: "#DCF7C5")
        
        static let incomingBubbleBackgroundDay = UIColor(hex: "#EAEBED")
        static let outgoingBubbleBackgroundDay = UIColor(hex: "#4389F9")
        
        static let incomingBubbleBackgroundNight = UIColor(hex: "#2E2E2E")
        static let outgoingBubbleBackgroundNight = UIColor(hex: "#5C5C5C")
        
        static let bubbleTextClassic = UIColor.black
        static let bubbleOutgoingTextDay = UIColor.white
        static let bubbleIncomingTextDay = UIColor(hex: "#060606")
        static let bubbleTextNight = UIColor.white
        
        static let sendMessagePlaceholder = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)
        
        // MARK: - Profile
        
        static let buttonBackgroundLight = UIColor(hex: "#F6F6F6")
        static let buttonBackgroundDark = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.20)
    }
}
