//
//  ProfileTests.swift
//  ProfileTests
//
//  Created by Артур Гайфуллин on 25.03.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsUpdateProfileDetailes() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidloadCalled)
    }
}
