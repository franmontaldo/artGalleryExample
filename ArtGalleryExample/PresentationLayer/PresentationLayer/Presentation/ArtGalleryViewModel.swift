//
//  ArtGalleryViewModel.swift
//  ArtGalleryExample
//
//  Created by francisco on 07/02/2024.
//

import SwiftUI
import Combine
import DataLayer

public protocol ArtGalleryViewModelProtocol: AnyObject {
    var pagination: Pagination? { get }
    var artworks: [ArtworkViewModel] { get }
    var error: Error? { get }
    
    func fetchArtworks()
    func loadNextPage()
}

public class ArtGalleryViewModel: ObservableObject, ArtGalleryViewModelProtocol {
    public var pagination: Pagination?
    private var currentPage = 2
    
    @Published public var error: Error?
    
    @Published public var artworks: [ArtworkViewModel] = []
    
    private let service: ArtAPIServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(service: ArtAPIServiceProtocol) {
        self.service = service
    }
    
    private func observeArtworkChanges() {
        artworks.forEach { artworkViewModel in
            artworkViewModel.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
    
    public func fetchArtworks() {
        service.fetchArtworks(page: 1, limit: 20)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { artworks, pagination in
                self.pagination = pagination
                self.artworks = artworks.map { ArtworkViewModel(artwork: $0, service: self.service) }
                self.observeArtworkChanges()
                self.artworks.forEach { $0.fetchArtworkImage() }
            }
            .store(in: &cancellables)
    }
    
    public func loadNextPage() {
        let totalPages = pagination?.totalPages ?? 1
        guard currentPage < totalPages else { return }
        service.fetchArtworks(page: currentPage + 1, limit: 20)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { artworks, pagination in
                self.pagination = pagination
                let newArtworks = artworks.map { ArtworkViewModel(artwork: $0, service: self.service) }
                self.artworks.append(contentsOf: newArtworks)
                self.currentPage += 1
                self.observeArtworkChanges()
                self.artworks.forEach { $0.fetchArtworkImage() }
            }
            .store(in: &cancellables)
    }
}


public protocol ArtworkViewModelProtocol: Identifiable {
    var id: Int { get }
    var title: String { get }
    var artistDisplay: String { get }
    var imageID: String? { get }
    var image: Image? { get }
    var error: Error? { get }
    
    func fetchArtworkImage()
}

public class ArtworkViewModel: ArtworkViewModelProtocol, ObservableObject, Equatable {
    public static func == (lhs: ArtworkViewModel, rhs: ArtworkViewModel) -> Bool { lhs.id == rhs.id }
    
    public let id: Int
    public let title: String
    public let artistDisplay: String
    public var imageID: String?
    let description: String?
    
    @Published public var error: Error?
    
    @Published public var image: Image?
    
    private let service: ArtAPIServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(artwork: Artwork, service: ArtAPIServiceProtocol) {
        self.service = service
        self.id = artwork.id
        self.title = artwork.title
        self.artistDisplay = artwork.artistDisplay ?? "Unknown"
        self.description = String(htmlString: artwork.description ?? "No description available")
        self.imageID = artwork.imageID
    }
    
    public func fetchArtworkImage() {
        guard let imageID = imageID else { return }
        service.fetchArtworkImage(withID: imageID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { image in
                self.image = image
            }
            .store(in: &cancellables)
    }
}
