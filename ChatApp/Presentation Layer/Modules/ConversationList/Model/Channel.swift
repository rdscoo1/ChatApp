//
//  Channel.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/26/21.
//

import Foundation
import Firebase

struct Channel {
    let identifier: String
    let name: String?
    let lastMessage: String?
    let lastActivity: Date?
}

extension Channel {

    init?(identifier: String, firestoreData: [String: Any]) {
        guard let name = firestoreData["name"] as? String else {
            return nil
        }
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
