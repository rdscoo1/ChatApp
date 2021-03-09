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
        
        static var buttonBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#FFFFFF", alpha: 0.2) :
                        UIColor(hex: "#F6F6F6")
                }
            } else {
                return UIColor(hex: "#F6F6F6")
            }
        }
        
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
        
        static let themeIsSelected = UIColor(hex: "#007AFF")
        static let themeNotSelected = UIColor(hex: "#979797")
        
        static let themesBackground = UIColor(hex: "#193661")
        
        // MARK: - App Theme Message Bubbles
        
        static let incomingBubbleClassic = UIColor(hex: "#DFDFDF")
        static let outgoingBubbleClassic = UIColor(hex: "#DCF7C5")
        
        static let incomingBubbleDay = UIColor(hex: "#EAEBED")
        static let outgoingBubbleDay = UIColor(hex: "#4389F9")
        
        static let incomingBubbleNight = UIColor(hex: "#2E2E2E")
        static let outgoingBubbleNight = UIColor(hex: "#5C5C5C")
    }
}
