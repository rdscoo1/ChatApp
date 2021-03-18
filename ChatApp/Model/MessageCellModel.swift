//
//  MessageCellModel.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/3/21.
//

import Foundation

struct MessageCellModel {
    let text: String
    let direction: MessageDirection
}

enum MessageDirection {
    case incoming
    case outgoing
}
