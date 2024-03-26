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
        
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
}
