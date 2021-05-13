//
//  ChannelsServiceMock.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 13.05.2021.
//

import Firebase
import Foundation
@testable import ChatApp

class ChannelServiceMock: IChannelsService {
    
    // MARK: - Public Properties
    
    var channels: [Channel]?
    var error: Error?
    var isSubscribedOnChannels = false
    
    // MARK: - Methods call counters

    private(set) var getChannelsCount = 0
    private(set) var subscribeOnChannelsCount = 0
    private(set) var createChannelCount = 0
    private(set) var removeChannelCount = 0
    
    // MARK: - Received Properties
    
    private(set) var receivedChannelId: String?
    private(set) var receivedChannelName: String?
    private(set) var removedChannelId: String?
    
    // MARK: - IChannelsService Conformance
    
    func subscribeOnChannels(completion: @escaping (Result<Bool, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            isSubscribedOnChannels = true
            subscribeOnChannelsCount += 1
            completion(.success(isSubscribedOnChannels))
        }
    }
    
    func createChannel(withName name: String, completion: @escaping (Result<String, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let receivedId = receivedChannelId {
            receivedChannelName = name
            createChannelCount += 1
            completion(.success(receivedId))
        }
    }
    
    func removeChannel(withId identifier: String) {
        removeChannelCount += 1
        removedChannelId = identifier
    }
}
