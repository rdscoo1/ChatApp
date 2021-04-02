//
//  DBMessage+Init.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/2/21.
//

import CoreData

extension DBMessage {
    convenience init(message: Message, in context: NSManagedObjectContext) {
        self.init(context: context)

        identifier = message.identifier
        content = message.content
        senderId = message.senderId
        senderName = message.senderName
        created = message.created
    }
}
