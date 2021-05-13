//
//  CoreDataManagerMock.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 13.05.2021.
//

import CoreData
@testable import ChatApp

class CoreDataManagerMock: ICoreDataManager {
    
    // MARK: - Public properties
    
    var fetchedEntities: ((NSManagedObjectContext) -> [NSManagedObject]?)?
    
    // MARK: - Methods call counters

    private(set) var performSaveCount = 0
    private(set) var fetchRecordsCount = 0

    // MARK: - Received CoreData Properties
    
    private(set) var receivedEntityName: String?
    private(set) var receivedPredicate: NSPredicate?

    // MARK: - ICoreDataManager
    
    var mainContext: NSManagedObjectContext {
        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        performSaveCount += 1
        block(mainContext)
    }
    
    func fetchRecordsForEntity(_ name: String, inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate?) -> [NSManagedObject]? {
        receivedEntityName = name
        receivedPredicate = predicate
        fetchRecordsCount += 1
        return fetchedEntities?(mainContext)
    }
    
}
