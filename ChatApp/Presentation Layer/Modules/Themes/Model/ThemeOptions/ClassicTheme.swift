//
//  ClassicTheme.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/12/21.
//

import UIKit

struct ClassicTheme: AppTheme {
    
    var name = Constants.LocalizationKey.classic.string
    
    var statusBarStyle: UIStatusBarStyle { .default }
    
    var colors = ThemeColors(
        primaryBackground: .white,
        navigationBar: .init(
            title: .black,
            background: .white,
            tint: Constants.Colors.settingsIconGray),
        conversationList: .init(
            table: .init(
                sectionHeaderTitle: .black,
                sectionHeaderBackground: .lightGray,
                separator: .lightGray),
            cell: .init(
                interlocutorName: Constants.Colors.titleTextLight,
                message: Constants.Colors.subtitleTextLight,
                receivedDate: Constants.Colors.subtitleTextLight,
                cellSelected: .lightGray,
                background: Constants.Colors.yellowLight)),
        conversation: .init(
            cell: .init(
                incoming: .init(
                    text: Constants.Colors.bubbleTextClassic,
                    background: Constants.Colors.incomingBubbleBackgroundClassic),
                outgoing: .init(
                    text: Constants.Colors.bubbleTextClassic,
                    background: Constants.Colors.outgoingBubbleBackgroundClassic))),
        profile: .init(
            name: .black,
            description: .black,
            saveButtonBackground: Constants.Colors.buttonBackgroundLight),
        themes: .init(
            text: .black,
            background: Constants.Colors.outgoingBubbleBackgroundClassic)
    )
    
}
