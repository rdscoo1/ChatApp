//
//  AppTheme.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/12/21.
//

import UIKit

protocol AppTheme {
    var name: String { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var colors: ThemeColors { get }
}

struct ThemeColors {
    let primaryBackground: UIColor
    let navigationBar: NavigationBar
    let conversationList: ConversationListVC
    let conversation: ConversationVC
    let profile: ProfileVC
    let themes: ThemesVC
}

struct NavigationBar {
    let title: UIColor
    let background: UIColor
    let tint: UIColor
}

struct ConversationListVC {
    let table: TableTheme
    
    let cell: CellTheme
    
    struct TableTheme {
        let sectionHeaderTitle: UIColor
        let sectionHeaderBackground: UIColor
        let separator: UIColor
    }
    
    struct CellTheme {
        let interlocutorName: UIColor
        let message: UIColor
        let receivedDate: UIColor
        let cellSelected: UIColor
        let background: UIColor
    }
}

struct ConversationVC {
    let cell: CellTheme
    
    struct CellTheme {
        let incoming: MessageTheme
        let outgoing: MessageTheme
    }
    
    struct MessageTheme {
        let text: UIColor
        let background: UIColor
    }
}

struct ProfileVC {
    let name: UIColor
    let description: UIColor
    let saveButtonBackground: UIColor
}

struct ThemesVC {
    let text: UIColor
    let background: UIColor
}
