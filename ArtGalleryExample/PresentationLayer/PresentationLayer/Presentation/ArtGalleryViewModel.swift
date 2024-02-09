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
    private var currentPage = 1
    
    @Published public var error: Error?
    
    @Published public var artworks: [ArtworkViewModel] = []
    
    private let service: ArtAPIServiceProtocol
    private let storageService: StorageServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(service: ArtAPIServiceProtocol, storage: StorageServiceProtocol) {
        self.service = service
        self.storageService = storage
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
        service.checkServerReachability() { isOnline, error  in
            if let error = error {
                self.error = error
            }
            if isOnline {
                self.service.fetchArtworks(page: 1, limit: 20)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { artworks, pagination in
                        self.pagination = pagination
                        self.artworks = artworks.map { ArtworkViewModel(artwork: $0, service: self.service, storage: self.storageService) }
                        self.observeArtworkChanges()
                        self.artworks.forEach { $0.fetchArtworkImage() }
                        self.storageService.updateArtworks(with: artworks)
                    }
                    .store(in: &self.cancellables)
            } else {
                self.storageService.fetchArtworks(page: 1, limit: 20)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { artworks, pagination in
                        self.pagination = pagination
                        let artworkvms = artworks.map { ArtworkViewModel(artwork: $0, service: self.service, storage: self.storageService) }
                        artworkvms.forEach {
                            $0.fetchArtworkImage()
                        }
                        self.artworks = artworkvms
                        self.observeArtworkChanges()
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
    
    public func loadNextPage() {
        let totalPages = pagination?.totalPages ?? 1
        guard currentPage < totalPages else { return }
        service.checkServerReachability() { isOnline, error in
            if let error = error {
                self.error = error
            }
            if isOnline {
                self.service.fetchArtworks(page: self.currentPage + 1, limit: 20)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { artworks, pagination in
                        self.pagination = pagination
                        let newArtworks = artworks.map { ArtworkViewModel(artwork: $0, service: self.service, storage: self.storageService) }
                        self.artworks.append(contentsOf: newArtworks)
                        self.currentPage += 1
                        self.observeArtworkChanges()
                        self.artworks.forEach { $0.fetchArtworkImage() }
                        self.storageService.updateArtworks(with: artworks)
                    }
                    .store(in: &self.cancellables)
            } else {
                self.storageService.fetchArtworks(page: self.currentPage + 1, limit: 20)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { artworks, pagination in
                        self.pagination = pagination
                        let newArtworks = artworks.map { ArtworkViewModel(artwork: $0, service: self.service, storage: self.storageService) }
                        self.artworks.append(contentsOf: newArtworks)
                        self.currentPage += 1
                        self.observeArtworkChanges()
                        self.artworks.forEach {
                            $0.fetchArtworkImage()
                        }
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
    
    public func refreshArtworks() {
        currentPage = 1
        artworks = []
        fetchArtworks()
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
    private let storageService: StorageServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(artwork: Artwork, service: ArtAPIServiceProtocol, storage: StorageServiceProtocol) {
        self.service = service
        self.storageService = storage
        self.id = artwork.id
        self.title = artwork.title
        self.artistDisplay = artwork.artistDisplay ?? "Unknown"
        self.description = String(htmlString: artwork.description ?? "No description available")
        self.imageID = artwork.imageID
    }
    
    public func fetchArtworkImage() {
        guard let imageID = imageID else { return }
        service.checkServerReachability() { isOnline, error in
            if let error = error {
                self.error = error
            }
            if isOnline {
                self.service.fetchArtworkImage(withID: imageID)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { (image, data) in
                        self.image = image
                        guard let imageID = self.imageID else { return }
                        self.storageService.pushArtworkImage(imageID: imageID, imageData: data)
                    }
                    .store(in: &self.cancellables)
            } else {
                self.storageService.fetchArtworkImage(withID: imageID)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { image in
                        self.image = image
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
}
