//
//  UserDataManagerTests.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 07.05.2021.
//

import XCTest
@testable import ChatApp

class UserDataManagerTests: XCTestCase {

    func testProfileIsSuccessfullyLoaded() throws {
        
        // Arrange
    
        let expectation = self.expectation(description: "Load user data")
        
        let userStorageManagerMock = UserStorageManagerMock()
        let userDataManager = UserDataManager(userStorageManager: userStorageManagerMock)
        let userData = UserViewModel(fullName: "Test User",
                            description: "iOS developer",
                            profileImage: nil)
        userStorageManagerMock.userViewModel = userData
        var receivedUser: UserViewModel?
        
        // Act
            
        userDataManager.loadProfile { profile in
            receivedUser = profile
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        
        XCTAssert(receivedUser == userStorageManagerMock.userViewModel)
        XCTAssertEqual(userStorageManagerMock.readFromDiskCount, 1)
    }
    
    func testProfileIsSuccessfullySaved() throws {
        
        // Arrange
        
        let expectation = self.expectation(description: "Save user data")
        
        let userStorageManagerMock = UserStorageManagerMock()
        let userDataManager = UserDataManager(userStorageManager: userStorageManagerMock)
        let defaultProfile = UserViewModel(fullName: "Test User", description: "iOS Developer", profileImage: nil)
        var isSavedSuccessfully = false
        
        // Act
        
        userDataManager.saveProfile(defaultProfile) { isSaved in
            isSavedSuccessfully = isSaved
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        
        XCTAssertEqual(userStorageManagerMock.isUserProfileSaved, isSavedSuccessfully)
        XCTAssertEqual(userStorageManagerMock.writeToDiskCount, 1)
    }

}
