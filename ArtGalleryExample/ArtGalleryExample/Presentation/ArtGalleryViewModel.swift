//
//  ArtGalleryViewModel.swift
//  ArtGalleryExample
//
//  Created by francisco on 07/02/2024.
//

import SwiftUI
import Combine

protocol ArtGalleryViewModelProtocol: AnyObject {
    var pagination: Pagination? { get }
    var artworks: [ArtworkViewModel] { get }
    var error: Error? { get }
    
    func fetchArtworks()
    func loadNextPage()
}

class ArtGalleryViewModel: ObservableObject, ArtGalleryViewModelProtocol {
    var pagination: Pagination?
    private var currentPage = 2
    
    @Published var error: Error?
    
    @Published var artworks: [ArtworkViewModel] = []
    
    private let service: ArtAPIServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: ArtAPIServiceProtocol) {
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
    
    func fetchArtworks() {
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
    
    func loadNextPage() {
        print(pagination?.totalPages)
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


protocol ArtworkViewModelProtocol: Identifiable {
    var id: Int { get }
    var title: String { get }
    var artistDisplay: String { get }
    var imageID: String? { get }
    var image: Image? { get }
    var error: Error? { get }
    
    func fetchArtworkImage()
}

class ArtworkViewModel: ArtworkViewModelProtocol, ObservableObject, Equatable {
    static func == (lhs: ArtworkViewModel, rhs: ArtworkViewModel) -> Bool { lhs.id == rhs.id }
    
    let id: Int
    let title: String
    let artistDisplay: String
    var imageID: String?
    
    @Published var error: Error?
    
    @Published var image: Image?
    
    private let service: ArtAPIServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(artwork: Artwork, service: ArtAPIServiceProtocol) {
        self.service = service
        self.id = artwork.id
        self.title = artwork.title
        self.artistDisplay = artwork.artistDisplay ?? "Unknown"
        self.imageID = artwork.imageID
    }
    
    func fetchArtworkImage() {
        guard let imageID = imageID else { return }
        if self.title == "Country Club Dance" {
            print("hola")
        }
        service.fetchArtworkImage(withID: imageID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { image in
                if self.title == "Country Club Dance" {
                    print("hola")
                }
                self.image = image
            }
            .store(in: &cancellables)
    }
}
