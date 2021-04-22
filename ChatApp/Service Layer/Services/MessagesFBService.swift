//
//  MessagesFBService.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/15/21.
//

import Firebase
import CoreData

protocol IMessagesFBService {
    func subscribeOnMessagesFromChannel(withId channelId: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func sendMessage(content: String, completion: @escaping (Result<String, Error>) -> Void)
    func deleteMessage(withId identifier: String, completion: @escaping (Error?) -> Void)
}

class MessagesFBService: IMessagesFBService {

    // MARK: - Private Properties

    private let channelId: String

    private let userDataManager: IUserDataManager

    private let coreDataManager: ICoreDataManager

    private lazy var database = Firestore.firestore()
    private lazy var messagesReference = {
        database.collection("channels/\(channelId)/messages")
    }()
    private var messagesListener: ListenerRegistration?

    // MARK: - Init

    init(channelId: String, userDataManager: IUserDataManager, coreDataManager: ICoreDataManager) {
        self.channelId = channelId
        self.userDataManager = userDataManager
        self.coreDataManager = coreDataManager
    }

    deinit {
        unsubscribe()
    }

    // MARK: - Methods

    func subscribeOnMessagesFromChannel(withId channelId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let channelId = self.channelId

        messagesListener = messagesReference.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = querySnapshot {
                DispatchQueue.global(qos: .default).async {

                    self.coreDataManager.performSave { context in

                        snapshot.documentChanges.forEach { diff in
                            switch diff.type {
                            case .added, .modified, .removed:
                                _ = DBMessage(identifier: diff.document.documentID,
                                              firestoreData: diff.document.data(),
                                              channelId: channelId,
                                              in: context)
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

    func sendMessage(content: String,
                     completion: @escaping (Result<String, Error>) -> Void) {
        guard let profile = userDataManager.profile else { return }

        var documentReference: DocumentReference?
        documentReference = messagesReference.addDocument(data: ["content": content,
                                                                 "senderId": userDataManager.identifier,
                                                                 "senderName": profile.fullName,
                                                                 "created": Timestamp(date: Date())]) { error in
            if let error = error {
                completion(.failure(error))
            } else if let documentId = documentReference?.documentID {
                completion(.success(documentId))
            }
        }
    }

    func deleteMessage(withId identifier: String, completion: @escaping (Error?) -> Void) {
        messagesReference.document(identifier).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    func unsubscribe() {
        messagesListener?.remove()
    }
}
