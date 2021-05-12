//
//  UserDataManagerTests.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 07.05.2021.
//

import XCTest
@testable import ChatApp

class UserDataManagerTests: XCTestCase {

    func testCallingMethods() throws {
        
        // Arrange
    
        let expectation = self.expectation(description: "Load user data")
        
        let userDataManagerMock = UserDataManagerMock()
        let profileDataManagerMock = UserStorageManagerMock()
        let userDataManager = UserDataManager(profileDataManager: profileDataManagerMock)
        let newProfile = User(fullName: "New Test FullName", description: "New Test Description", profileImageUrl: "newTestImage.png")
        var receivedUser: UserViewModel?
        
        // Act
            
        userDataManager.loadProfile { profile in
            receivedUser = profile
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        
//        XCTAssertEqual(receivedUser, userDataManagerMock.defaultProfile)
        XCTAssertEqual(profileDataManagerMock.readFromDiskCount, 1)
    }

}
