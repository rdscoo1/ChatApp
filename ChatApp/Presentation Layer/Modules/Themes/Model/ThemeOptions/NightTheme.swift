//
//  NightTheme.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/12/21.
//

import UIKit

struct NightTheme: AppTheme {
    
    var name = Constants.LocalizationKey.night.string
    
    var statusBarStyle: UIStatusBarStyle { .lightContent }
    
    var colors = ThemeColors(
        primaryBackground: Constants.Colors.primaryNightBackground,
        navigationBar: .init(
            title: .white,
            background: Constants.Colors.navigationBarBackgroundNight,
            tint: .white,
            closeIconTint: Constants.Colors.closeIconDarkTint,
            closeButtonBackground: Constants.Colors.closeButtonDarkBackground),
        conversationList: .init(
            table: .init(
                sectionHeaderTitle: .white,
                sectionHeaderBackground: .darkGray,
                separator: .darkGray),
            cell: .init(
                interlocutorName: Constants.Colors.titleTextDark,
                message: Constants.Colors.subtitleTextDark,
                receivedDate: Constants.Colors.subtitleTextDark,
                cellSelected: .darkGray,
                background: Constants.Colors.yellowDark)),
        conversation: .init(
            cell: .init(
                incoming: .init(
                    text: Constants.Colors.bubbleTextNight,
                    background: Constants.Colors.incomingBubbleBackgroundNight),
                outgoing: .init(
                    text: Constants.Colors.bubbleTextNight,
                    background: Constants.Colors.outgoingBubbleBackgroundNight))),
        profile: .init(
            name: .white,
            description: .white,
            buttonTitle: Constants.Colors.buttonTitleDark,
            saveButtonBackground: Constants.Colors.buttonBackgroundDark),
        themes: .init(
            text: .black,
            background: Constants.Colors.outgoingBubbleBackgroundNight)
    )
    
}
