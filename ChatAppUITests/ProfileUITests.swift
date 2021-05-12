//
//  ProfileUITests.swift
//  ChatAppUITests
//
//  Created by Roman Khodukin on 05.05.2021.
//

@testable import ChatApp
import XCTest

class ProfileUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
    func testTextViewExist() throws {
        app.launch()
       
        app.navigationBars.buttons["profileLogoImageView"].tap()
        
        XCTAssertTrue(app.textViews["profileNameTextView"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.textViews["profileDescriptionTextView"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["editButton"].waitForExistence(timeout: 2))
    }
    
}
