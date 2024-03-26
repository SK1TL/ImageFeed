//
//  ImagesListTests.swift
//  ImagesListTests
//
//  Created by Артур Гайфуллин on 25.03.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsFetchPhotosNextPage() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
}
