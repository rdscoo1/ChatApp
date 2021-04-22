//
//  ChannelsFBService.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/15/21.
//

import Firebase
import CoreData

protocol IChannelsFBService {
    func subscribeOnChannels(completion: @escaping (Result<Bool, Error>) -> Void)
    func createChannel(withName name: String, completion: @escaping (Result<String, Error>) -> Void)
    func removeChannel(withId identifier: String)
}

class ChannelsFBService: IChannelsFBService {

    // MARK: - Private Properties

    let servicesAssembly: IServicesAssembly
    private let coreDataManager: ICoreDataManager

    private lazy var database = Firestore.firestore()
    private lazy var channelsCollection = database.collection("channels")
    private var messagesListener: ListenerRegistration?

    // MARK: - Init

    init(servicesAssembly: IServicesAssembly, coreDataManager: ICoreDataManager) {
        self.servicesAssembly = servicesAssembly
        self.coreDataManager = coreDataManager
    }

    deinit {
        unsubscribe()
    }

    // MARK: - Methods

    func subscribeOnChannels(completion: @escaping (Result<Bool, Error>) -> Void) {
        channelsCollection.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = querySnapshot {
                DispatchQueue.global(qos: .default).async {

                    CoreDataManager.shared.performSave { context in

                        snapshot.documentChanges.forEach { diff in
                            switch diff.type {
                            case .added, .modified:
                                _ = DBChannel(identifier: diff.document.documentID,
                                              firestoreData: diff.document.data(),
                                              in: context)
                            case .removed:
                                let id = diff.document.documentID
                                CoreDataManager.shared.removeChannelFromDB(channelId: id)
                            }
                        }
                        completion(.success(true))
                    }
                }
            } else {
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }

    func createChannel(withName name: String, completion: @escaping (Result<String, Error>) -> Void) {
        var documentReference: DocumentReference?
        documentReference = channelsCollection.addDocument(data: ["name": name]) { (error) in
            if let error = error {
                completion(.failure(error))
            }

            if let channelId = documentReference?.documentID {
                completion(.success(channelId))
            }
        }
    }

    func removeChannel(withId identifier: String) {
        deleteChannel(withId: identifier) { isSuccess in
            CoreDataManager.shared.performSave { context in
                guard isSuccess,
                      let channel = CoreDataManager.shared
                        .fetchRecordsForEntity("DBChannel",
                                               inContext: context,
                                               withPredicate: NSPredicate(format: "identifier == %@", identifier))?.first as? DBChannel
                else { return }

                context.delete(channel)
            }
        }
    }

    private func deleteChannel(withId identifier: String, completion: @escaping (Bool) -> Void) {
        let messageService = servicesAssembly.messagesFBService(channelId: identifier)

        channelsCollection.document(identifier).collection("messages").getDocuments { (querySnapshot, error) in
            if error != nil {
                completion(false)
            } else if let snapshot = querySnapshot {
                snapshot.documents.forEach { document in
                    messageService.deleteMessage(withId: document.documentID) { error in
                        completion(error == nil)
                    }
                }
            } else {
                completion(false)
            }
        }

        channelsCollection.document(identifier).delete { error in
            completion(error == nil)
        }
    }

    func unsubscribe() {
        messagesListener?.remove()
    }
}
