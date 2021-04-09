//
//  DBChannel+Init.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/2/21.
//

import CoreData

extension DBChannel {
    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)

        identifier = channel.identifier
        name = channel.name
        lastMessage = channel.lastMessage
        lastActivity = channel.lastActivity
    }
}
