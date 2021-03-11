////
////  Appearance.swift
////  ChatApp
////
////  Created by Roman Khodukin on 3/11/21.
////
//
//import UIKit
//
//class Appearance {
//    
//    // MARK: - Singleton
//    
//    static let shared = Appearance()
//    private init() {}
//    
//    // MARK: - Themes
//    
//    var themes: [Theme] = [
//        .init(id: 0,
//              type: .classic,
//              incomingMessageColor: Constants.Colors.incomingBubbleClassic,
//              outgoingMessageColor: Constants.Colors.outgoingBubbleClassic,
//              labelColor: Constants.Colors.titleTextLight,
//              backgroundColor: .white,
//              statusBarStyle: .default,
//              grayColor: Constants.Colors.lightGray,
//              yellowColor: Constants.Colors.yellowLight,
//              uiUserInterfaceStyle: .light),
//        .init(id: 1,
//              type: .day,
//              incomingMessageColor: Constants.Colors.incomingBubbleDay,
//              outgoingMessageColor: Constants.Colors.outgoingBubbleDay,
//              labelColor: Constants.Colors.titleTextLight,
//              backgroundColor: .white,
//              statusBarStyle: .default,
//              grayColor: Constants.Colors.lightGray,
//              yellowColor: Constants.Colors.yellowLight,
//              uiUserInterfaceStyle: .light),
//        .init(id: 2,
//              type: .night,
//              incomingMessageColor: Constants.Colors.incomingBubbleNight,
//              outgoingMessageColor: Constants.Colors.outgoingBubbleNight,
//              labelColor: Constants.Colors.titleTextDark,
//              backgroundColor: .black,
//              statusBarStyle: .lightContent,
//              grayColor: Constants.Colors.darkGray,
//              yellowColor: Constants.Colors.yellowDark,
//              uiUserInterfaceStyle: .dark),
//    ]
//    
//    
//    // MARK: - UserDefaults saving theme
//    
//    private var currentThemeId: Int {
//        get {
//            UserDefaults.standard.integer(forKey: "CurrentTheme")
//        }
//        set {
//            currentTheme = themes.first(where: { $0.id == newValue })
//            UserDefaults.standard.setValue(newValue, forKey: "CurrentTheme")
//        }
//    }
//    
//    
//    private(set) lazy var currentTheme = themes.first(where: { $0.id == currentThemeId })
//    
//}
