//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 22.03.2023.
//

import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {
	func testGetNewPhotoFromPresenter() throws {
		//given
		let imageServiceMock = ImageListServiceStub()
		let presenter = ImageListPresenter(imageListService: imageServiceMock)
		
		//when
		presenter.fetchPhotosNextPage()
		presenter.updatePhotos()
		
		//then
		XCTAssertTrue(presenter.photos.count == 3)
	}
	
	func testDidInsertedRowsAfterFetching() throws {
		//given
		let imageServiceMock = ImageListServiceStub()
		let presenter = ImageListPresenter(imageListService: imageServiceMock)
		let imageListVCSpy = ImageListVCSpy()
		imageListVCSpy.configure(presenter)
		
		//when
		presenter.fetchPhotosNextPage()
		
		//then
		XCTAssertTrue(imageListVCSpy.didInsertedRowsAfterFetching == true)
	}
}
