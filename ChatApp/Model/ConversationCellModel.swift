//
//  ConversationCellModel.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/27/21.
//

import UIKit

struct ConversationCellModel {
    let photo: UIImage?
    let name: String?
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}
