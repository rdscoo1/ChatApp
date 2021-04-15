//
//  DBChannel+Init.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/2/21.
//

import Firebase
import CoreData

extension DBChannel {
    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)

        identifier = channel.identifier
        name = channel.name
        lastMessage = channel.lastMessage
        lastActivity = channel.lastActivity
    }

    convenience init?(identifier: String, firestoreData: [String: Any], in context: NSManagedObjectContext) {
        guard let name = firestoreData["name"] as? String,
              !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        self.init(context: context)

        self.identifier = identifier
        self.name = name
        self.lastMessage = firestoreData["lastMessage"] as? String
        if let timeStamp = firestoreData["lastActivity"] as? Timestamp {
            self.lastActivity = timeStamp.dateValue()
        } else {
            self.lastActivity = nil
        }
    }
}
