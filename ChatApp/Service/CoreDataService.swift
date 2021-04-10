//
//  CoreDataService.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/2/21.
//

import CoreData

class CoreDataService {

    static let tagForLogger = "\(CoreDataService.self)"

    // MARK: - Singleton

    static let shared = CoreDataService()

    private init() { }

    lazy var didDBUpdated: (() -> Void)? = { [weak self] in
        self?.printCoreDataObjectsStats()
    }

    // MARK: - Private Properties

    private let modelName: String = "ChatApp"
    private let modelExtension: String = "momd"

    // Getting path to Database file
    private lazy var applicationDocumentsDirectory: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("documents path not found")
        }
        return documentsUrl.appendingPathComponent("\(modelName).sqlite")
    }()

    // MARK: - Contexts

    private lazy var writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writeContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()

    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }

    // MARK: - Managed Object Model

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: modelName, withExtension: modelExtension) else {
            fatalError("Failed to find NSManagedObjectModel")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Failed to create NSManagedObjectModel")
        }
        return managedObjectModel
    }()

    // MARK: - Persistent Store Coordinator

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: applicationDocumentsDirectory,
                                                              options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }

        return persistentStoreCoordinator
    }()

    // MARK: - Save Context Support

    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }

    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
    }

    // MARK: - Save Data Support

    func saveChannels(channels: [Channel]) {
        performSave { context in
            channels.forEach { _ = DBChannel(channel: $0, in: context) }
        }
    }

    func saveMessagesBy(id: String, messages: [Message]) {
        performSave { context in
            messages.forEach { _ = DBMessage(message: $0, in: context) }
        }
    }

    // MARK: - Remove Channel

    func removeChannelFromDB(channelId: String) {
        let context = mainContext

        if let channel = fetchRecordsForEntity("DBChannel",
                                   inContext: context,
                                   withPredicate: NSPredicate(format: "identifier == %@", channelId))?.first as? DBChannel {
            context.delete(channel)
            do {
                try mainContext.save()
            } catch {
                print("deleting error -> \(error.localizedDescription)")
            }
        }
    }

    func removeAllChannels() {
        CoreDataService.shared.performSave { (context) in
            if let result = try? context.fetch(DBChannel.fetchRequest()) as? [DBChannel] {
                result.forEach {
                    context.delete($0)
                }
            }
        }
    }

    // MARK: - Fetch Records for Entity

    func fetchRecordsForEntity<T>(_ name: T,
                                  inContext context: NSManagedObjectContext,
                                  withPredicate predicate: NSPredicate? = nil) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: String(describing: name.self))
        fetchRequest.predicate = predicate

        if let result = try? context.fetch(fetchRequest) {
            return result
        } else {
            return nil
        }
    }

    // MARK: - Logging observer

    func setupObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(managedObjectContextDidChange(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: mainContext)
    }

    @objc private func managedObjectContextDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        didDBUpdated?()

        guard let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
              inserts.count > 0
        else { return }

        guard let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
              updates.count > 0
        else { return }

        guard let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
              deletes.count > 0
        else { return }

        Logger.printLogFrom(CoreDataService.tagForLogger, "Добавлено объектов -> \(inserts.count)")
        Logger.printLogFrom(CoreDataService.tagForLogger, "Обновлено объектов -> \(updates.count)")
        Logger.printLogFrom(CoreDataService.tagForLogger, "Удалено объектов -> \(deletes.count)")
    }

    func printCoreDataObjectsStats() {
        mainContext.perform { [weak self] in
            do {
                guard let channelsQuantity = try self?.mainContext.count(for: DBChannel.fetchRequest()),
                      let messagesQuantity = try self?.mainContext.count(for: DBMessage.fetchRequest())
                else { return }

                Logger.printLogFrom(CoreDataService.tagForLogger, "Каналов в базе -> \(channelsQuantity)")
                Logger.printLogFrom(CoreDataService.tagForLogger, "Сообщений в базе -> \(messagesQuantity) ")
            } catch let error {
                print("В базе ошибка \(error.localizedDescription)")
            }
        }
    }

    func printApplicationDocumentsDirectory() {
        print("📂 CoreData Path 📂\n\(applicationDocumentsDirectory)")
    }
}
