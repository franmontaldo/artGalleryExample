//
//  ArtGalleryViewModel.swift
//  ArtGalleryExample
//
//  Created by francisco on 07/02/2024.
//

import SwiftUI

protocol ArtGalleryViewModelProtocol: AnyObject {
    var pagination: Pagination? { get }
    var artworks: [ArtworkViewModel] { get }
    var isLoading: Bool { get }
    var error: Error? { get }
    
    func fetchArtworks()
    func loadNextPage()
}

class ArtGalleryViewModel: ArtGalleryViewModelProtocol, ObservableObject {
    private let artAPIService: ArtAPIServiceProtocol
    private var currentPage = 1
    private var isFetching = false
    
    @Published var pagination: Pagination?
    @Published var artworks: [ArtworkViewModel] = []
    var isLoading: Bool = false
    @Published var error: Error?
    
    init(artAPIService: ArtAPIServiceProtocol) {
        self.artAPIService = artAPIService
    }
    
    func fetchArtworks() {
        guard !isFetching else { return }
        isFetching = true
        isLoading = true
        
        artAPIService.fetchArtworks(page: 1, limit: 20) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            self.isLoading = false
            
            switch result {
            case .success(let artworks):
                self.artworks = artworks.map { artwork in
                    return ArtworkViewModel(
                        id: artwork.id,
                        title: artwork.title,
                        artistDisplay: artwork.artistDisplay ?? "Unknown",
                        thumbnail: artwork.thumbnail ?? nil
                    )
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func loadNextPage() {
        guard !isFetching else { return }
        let totalPages = pagination?.totalPages ?? 1
        guard currentPage < totalPages else { return }
        
        isFetching = true
        
        artAPIService.fetchArtworks(page: currentPage + 1, limit: 20) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let artworks):
                self.currentPage += 1
                let newArtworks = artworks.map { artwork in
                    return ArtworkViewModel(
                        id: artwork.id,
                        title: artwork.title,
                        artistDisplay: artwork.artistDisplay ?? "Unknown",
                        thumbnail: artwork.thumbnail ?? nil
                    )
                }
                self.artworks.append(contentsOf: newArtworks)
            case .failure(let error):
                self.error = error
            }
        }
    }
}

protocol ArtworkViewModelProtocol: Identifiable {
    var id: Int { get }
    var title: String { get }
    var artistDisplay: String { get }
    var thumbnail: Image? { get }
}

class ArtworkViewModel: ArtworkViewModelProtocol, Equatable {
    static func == (lhs: ArtworkViewModel, rhs: ArtworkViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let title: String
    let artistDisplay: String
    let thumbnail: Image?
    
    init(id: Int, title: String, artistDisplay: String, thumbnail: Thumbnail?) {
        self.id = id
        self.title = title
        self.artistDisplay = artistDisplay
        // TODO: transform thumbnail to a swiftui Image
        guard let prefixRange = thumbnail?.lqip.range(of: "base64,"),
              let data = Data(base64Encoded: String((thumbnail?.lqip[prefixRange.upperBound...])!)),
              let image = UIImage(data: data) else {
            self.thumbnail = nil
            return
        }
        self.thumbnail = Image(uiImage: image)
    }
}


