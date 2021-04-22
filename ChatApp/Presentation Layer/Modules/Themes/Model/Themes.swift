//
//  Themes.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/12/21.
//

import Foundation

struct Themes {
    
    static private(set) var current: AppTheme = ThemeOptions.classic.theme
    
    static private(set) var currentThemeOption: ThemeOptions = .classic {
        didSet {
            current = currentThemeOption.theme
        }
    }
        
    private static let themeStoreKey = "AppTheme"
    
    static func loadApplicationTheme() {
        let themeOption: ThemeOptions
        if let storedKey = UserDefaults.standard.string(forKey: themeStoreKey) {
            themeOption = ThemeOptions(storedKey: storedKey)
        } else {
            themeOption = .classic
        }
        currentThemeOption = themeOption
    }
    
    static func saveApplicationTheme(_ themeOption: ThemeOptions) {
        UserDefaults.standard.set(themeOption.rawValue, forKey: themeStoreKey)
        currentThemeOption = themeOption
    }
    
}

enum ThemeOptions: String, CaseIterable {
    
    case classic
    case day
    case night
    
    var theme: AppTheme {
        switch self {
        case .classic:
            return ClassicTheme()
        case .day:
            return DayTheme()
        case .night:
            return NightTheme()
        }
    }
    
    init(storedKey: String) {
        self = ThemeOptions(rawValue: storedKey) ?? .classic
    }
        
}
