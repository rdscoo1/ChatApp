//
//  DBMessage+CoreDataProperties.swift
//  
//
//  Created by Roman Khodukin on 4/10/21.
//
//

import Foundation
import CoreData

extension DBMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBMessage> {
        return NSFetchRequest<DBMessage>(entityName: "DBMessage")
    }

    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var identifier: String?
    @NSManaged public var senderId: String?
    @NSManaged public var senderName: String?
    @NSManaged public var channel: DBChannel?

}
