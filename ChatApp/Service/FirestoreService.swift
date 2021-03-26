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

    // MARK: - Public Methods

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

    func subscribeOnChannels(completion: @escaping (Result<[Channel], Error>) -> Void) {
        channelsCollection.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = querySnapshot?.documents else {
                print("There is no documents")
                return
            }

            let channels = documents
                .compactMap { Channel(identifier: $0.documentID,
                                      firestoreData: $0.data()) }
                .sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date()})

            completion(.success(channels))
        }
    }

    func fetchMessagesForChannel(withId channelId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
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
                .compactMap { Message(firestoreData: $0.data()) }
                .sorted(by: { $0.created > $1.created })

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

    func unsubscribe() {
        listener?.remove()
    }
}
