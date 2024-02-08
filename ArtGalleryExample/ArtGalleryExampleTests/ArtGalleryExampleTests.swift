//
//  ArtGalleryExampleTests.swift
//  ArtGalleryExampleTests
//
//  Created by francisco on 02/02/2024.
//

import XCTest
import Combine
@testable import ArtGalleryExample
@testable import DataLayer
@testable import PresentationLayer
import SwiftUI

class ArtGalleryViewModelTests: XCTestCase {
    
    var viewModel: ArtGalleryViewModel!
    var service: MockArtAPIService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        service = MockArtAPIService()
        viewModel = ArtGalleryViewModel(service: service)
    }
    
    override func tearDown() {
        viewModel = nil
        service = nil
        super.tearDown()
    }
    
    func testFetchArtworksSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch artworks success")
        let artwork = DataLayer.Artwork(id: 1, title: "Artwork 1", artistDisplay: "Artist 1", dateDisplay: "2022", mediumDisplay: "Oil on canvas", description: "Description 1", imageID: "1")
        let pagination = DataLayer.Pagination(total: 1, limit: 20, offset: 0, totalPages: 1, currentPage: 1, nextURL: "")
        let response: (artworks: [DataLayer.Artwork], pagination: DataLayer.Pagination) = ([artwork], pagination)
        service.mockArtworksResponse = response
        var receivedArtworks: [ArtworkViewModel] = []
        
        // Act
        viewModel.fetchArtworks()
        viewModel.$artworks
            .sink { artworks in
                guard !artworks.isEmpty else { return }
                receivedArtworks = artworks
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Assert
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(receivedArtworks.count, 1)
        XCTAssertEqual(receivedArtworks.first?.id, artwork.id)
        XCTAssertEqual(receivedArtworks.first?.title, artwork.title)
        XCTAssertEqual(receivedArtworks.first?.artistDisplay, artwork.artistDisplay)
        XCTAssertEqual(receivedArtworks.first?.description, artwork.description)
        XCTAssertEqual(receivedArtworks.first?.imageID, artwork.imageID)
    }
}

class MockArtAPIService: ArtAPIServiceProtocol {
    var mockArtworksResponse: (artworks: [DataLayer.Artwork], pagination: DataLayer.Pagination)?
    var mockError: Error?
    
    func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [DataLayer.Artwork], pagination: DataLayer.Pagination), Error> {
        if let mockArtworksResponse = mockArtworksResponse {
            return Just(mockArtworksResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if let mockError = mockError {
            return Fail(error: mockError)
                .eraseToAnyPublisher()
        } else {
            fatalError("Mock data or error not set for fetchArtworks")
        }
    }
    
    func fetchArtworkImage(withID imageID: String) -> AnyPublisher<Image, Error> {
        let dummyImage = Image(systemName: "photo")
        return Just(dummyImage)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
