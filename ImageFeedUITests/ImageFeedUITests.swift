//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Артур Гайфуллин on 25.03.2024.
//

import XCTest

final class Image_FeedUITests: XCTestCase {
   
    private let app = XCUIApplication()
    
    enum TestConstants {
        static let email = "SSSK1TLLL@yandex.ru" // your email on Unsplash.com
        static let password = "Rde696a1" // your password from Unsplash.com
        static let name = "Artur Gaifullin" // your full name on Unsplash.com
        static let userName = "@sk1tl" // your userName on Unsplash.com
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        let enterButton = app.buttons["Authenticate"]
        
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        enterButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 3))
        
        loginTextField.tap()
        loginTextField.typeText(TestConstants.email)
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(TestConstants.password)
        webView.swipeUp()
        
        sleep(3)
        
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 5))
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
        sleep(2)
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        sleep(3)
        
        cell.swipeUp()
        sleep(3)
        
        let cellToLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(3)
        cellToLike.buttons["likeButton"].tap()
        sleep(3)
        
        cellToLike.tap()
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        XCTAssertTrue(app.buttons["backButton"].waitForExistence(timeout: 3))
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 1).waitForExistence(timeout: 3))
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.buttons["logoutButton"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[TestConstants.name].exists)
        XCTAssertTrue(app.staticTexts[TestConstants.userName].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["logoutAlert"].scrollViews.otherElements.buttons["yesButton"].tap()
        
        sleep(2)
        XCTAssert(app.buttons["Authenticate"].waitForExistence(timeout: 10))
    }
}
