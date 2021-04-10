//
//  FirestoreService.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/26/21.
//

import Foundation
import Firebase

class FirestoreService {

    // MARK: - Private Properties

    private lazy var database = Firestore.firestore()

    private lazy var channelsCollection = database.collection("channels")

    private var messagesReference: CollectionReference?
    private var listener: ListenerRegistration?

    // MARK: - Channels Stack

    func subscribeOnChannels(completion: @escaping (Result<Bool, Error>) -> Void) {
        channelsCollection.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = querySnapshot {
                DispatchQueue.global(qos: .default).async {
                    
                    CoreDataService.shared.performSave { context in

                        snapshot.documentChanges.forEach { diff in
                            switch diff.type {
                            case .added, .modified:
                                _ = DBChannel(identifier: diff.document.documentID,
                                              firestoreData: diff.document.data(),
                                              in: context)
                            case .removed:
                                let id = diff.document.documentID
                                CoreDataService.shared.removeChannelFromDB(channelId: id)
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
            CoreDataService.shared.performSave { context in
                guard isSuccess,
                      let channel = CoreDataService.shared
                        .fetchRecordsForEntity("DBChannel",
                                               inContext: context,
                                               withPredicate: NSPredicate(format: "identifier == %@", identifier))?.first as? DBChannel
                else { return }

                context.delete(channel)
            }
        }
    }

    func deleteChannel(withId identifier: String, completion: @escaping (Bool) -> Void) {
        channelsCollection.document(identifier).collection("messages").getDocuments { (querySnapshot, error) in
            if error != nil {
                completion(false)
            } else if let snapshot = querySnapshot {
                snapshot.documents.forEach { document in
                    self.deleteMessage(withId: document.documentID) { error in
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

    // MARK: - Messages Stack

    func subscribeOnMessagesFromChannel(withId channelId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        messagesReference = channelsCollection.document(channelId).collection("messages")
        listener = messagesReference?.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = querySnapshot?.documents else {
                print("There is no documents")
                return
            }

            let messages = documents
                .compactMap { Message(identifier: $0.documentID, firestoreData: $0.data()) }
                .sorted(by: { $0.created > $1.created })

            CoreDataService.shared.saveMessagesBy(id: channelId, messages: messages)

            completion(.success(messages))
        }
    }

    func sendMessage(content: String,
                     completion: @escaping (Result<String, Error>) -> Void) {
        var documentReference: DocumentReference?
        documentReference = messagesReference?.addDocument(data: ["content": content,
                                                                  "senderId": UserData.shared.identifier,
                                                                  "senderName": UserData.shared.name,
                                                                  "created": Timestamp(date: Date())]) { error in
            if let error = error {
                completion(.failure(error))
            } else if let documentId = documentReference?.documentID {
                completion(.success(documentId))
            }
        }
    }

    func deleteMessage(withId identifier: String, completion: @escaping (Error?) -> Void ) {
        messagesReference?.document(identifier).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    func unsubscribe() {
        listener?.remove()
    }
}
