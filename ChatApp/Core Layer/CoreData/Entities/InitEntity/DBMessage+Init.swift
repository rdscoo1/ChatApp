//
//  DBMessage+Init.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/2/21.
//

import Firebase
import CoreData

extension DBMessage {

    var isMyMessage: Bool {
        return senderId == UserDataManager.shared.identifier
    }

    convenience init(message: Message, in context: NSManagedObjectContext) {
        self.init(context: context)

        identifier = message.identifier
        content = message.content
        senderId = message.senderId
        senderName = message.senderName
        created = message.created
    }

    convenience init?(identifier: String, firestoreData: [String: Any], channelId: String, in context: NSManagedObjectContext) {
        guard let content = firestoreData["content"] as? String,
              let senderId = firestoreData["senderId"] as? String,
              let senderName = firestoreData["senderName"] as? String,
              let created = firestoreData["created"] as? Timestamp  else { return nil }
        self.init(context: context)
        self.identifier = identifier
        self.channelId = channelId
        self.content = content
        self.senderId = senderId
        self.senderName = senderName
        self.created = created.dateValue()
    }
}
