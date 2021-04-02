//
//  Message.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/26/21.
//

import Foundation
import Firebase

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

extension Message {

    var isMyMessage: Bool {
        return senderId == UserData.shared.identifier
    }

    init?(identifier: String, firestoreData: [String: Any]) {

        guard let content = firestoreData["content"] as? String,
              let senderId = firestoreData["senderId"] as? String,
              let senderName = firestoreData["senderName"] as? String,
              let created = firestoreData["created"] as? Timestamp  else { return nil }
        
        self.identifier = identifier
        self.content = content
        self.senderId = senderId
        self.senderName = senderName
        self.created = created.dateValue()
    }
}
