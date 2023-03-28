//
//  ImageListVCSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Kirillov on 22.03.2023.
//
import Foundation
@testable import ImageFeed

final class ImageListVCSpy: IImageListViewControllerProtocol {
	var didInsertedRowsAfterFetching: Bool = false
	var presenter: IImageListPresenterProtocol?
	
	func updateTableViewAnimated(startIndex: Int, newCount: Int) {
		didInsertedRowsAfterFetching = true
	}
	
	func configure(_ presenter: IImageListPresenterProtocol) {
		self.presenter = presenter
		self.presenter?.view = self
	}
}
