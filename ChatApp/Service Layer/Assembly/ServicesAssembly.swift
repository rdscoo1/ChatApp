//
//  ServicesAssembly.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/16/21.
//

import CoreData

protocol IServicesAssembly {
    var userDataManager: UserDataManager { get }
    var cameraAccessManager: ICameraAccessManager { get }

    func pixabayService() -> IPixabayService

    func channelsService() -> IChannelsService
    func channelsFetchedResultsController() -> NSFetchedResultsController<DBChannel>

    func messagesService(channelId: String) -> MessagesService
    func messagesFetchedResultsController(channelId: String) -> NSFetchedResultsController<DBMessage>
}

class ServicesAssembly: IServicesAssembly {

    // MARK: - Private Property

    private let coreAssembly: ICoreAssembly

    // MARK: - Public Property

    lazy var userDataManager: UserDataManager = {
        let userDataManager = UserDataManager(userStorageManager: coreAssembly.userStorageManager())
        return userDataManager
    }()
    
    lazy var cameraAccessManager: ICameraAccessManager = CameraAccessManager()

    // MARK: - Init

    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }

    // MARK: - Methods

    func pixabayService() -> IPixabayService {
        let networkManager = coreAssembly.networkManager()
        let service = PixabayService(networkManager: networkManager)
        return service
    }
    
    func channelsService() -> IChannelsService {
        let channelsFBService = ChannelsService(servicesAssembly: self,
                                                  coreDataManager: coreAssembly.coreDataManager())
        return channelsFBService
    }
    
    func channelsFetchedResultsController() -> NSFetchedResultsController<DBChannel> {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                               NSSortDescriptor(key: "lastActivity", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchBatchSize = 20
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: coreAssembly.coreDataManager().mainContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
    
    func messagesService(channelId: String) -> MessagesService {
        let messagesFBService = MessagesService(channelId: channelId,
                                                  userDataManager: userDataManager,
                                                  coreDataManager: coreAssembly.coreDataManager())
        return messagesFBService
    }
    
    func messagesFetchedResultsController(channelId: String) -> NSFetchedResultsController<DBMessage> {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        fetchRequest.predicate = .init(format: "channelId == %@", channelId)
        fetchRequest.fetchBatchSize = 20
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: coreAssembly.coreDataManager().mainContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
}
