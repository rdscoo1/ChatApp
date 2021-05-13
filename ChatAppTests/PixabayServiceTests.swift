//
//  PixabayServiceTests.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 14.05.2021.
//

import XCTest
@testable import ChatApp

class PixabayServiceTests: XCTestCase {

    func testService() throws {
        
        // Arrange
        
//        let expectation = self.expectation(description: "test")
        let requestStub = RequestStub()
        let parserStub = ParserStub()
        let networkManager = NetworkManager()
        
        // Act
        
        networkManager.makeRequest(request: requestStub,
                                   parser: parserStub) { result in
//            switch result {
//            case .success(let searchResponse):
//                let model = searchResponse.hits?.compactMap { PixabayImage(previewUrl: $0.previewUrl,
//                                                                           fullUrl: $0.fullUrl) } ?? []
//                completion(.success(model))
//            case .failure(let error):
//                completion(.failure(error))
//            }
        }
        
        // Assert
        
        
        
    }

}
