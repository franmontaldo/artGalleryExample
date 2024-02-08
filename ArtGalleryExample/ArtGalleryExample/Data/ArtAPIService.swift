//
//  ArtAPIService.swift
//  ArtGalleryExample
//
//  Created by francisco on 02/02/2024.
//

import Foundation
import Alamofire
import UIKit
import SwiftUI
import Combine

protocol ArtAPIServiceProtocol {
    func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [Artwork], pagination: Pagination), Error>
    func fetchArtworkImage(withID imageID: String) -> AnyPublisher<Image, Error>
//    func fetchArtist(artistId: Int) -> AnyPublisher<ArtistData, Error>

}

class ArtAPIService: ArtAPIServiceProtocol {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [Artwork], pagination: Pagination), Error> {
        let url = Endpoint.baseURL.rawValue + "artworks"
        let parameters: [String: Any] = ["page": page, "limit": limit]

        return session
            .request(url, parameters: parameters)
            .publishDecodable(type: ArtworkResponse.self)
            .tryMap { response in
                guard let artworksData = response.value?.artworksData,
                      let pagination = response.value?.pagination else {
                    throw URLError(.badServerResponse)
                }
                return (artworks: artworksData, pagination: pagination)
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }


    func fetchArtworkImage(withID imageID: String) -> AnyPublisher<Image, Error> {
        let imageURL = Endpoint.imageBaseURL.rawValue + "\(imageID)/full/400,/0/default.jpg"
        return session
            .request(imageURL)
            .publishData()
            .tryMap { dataResponse -> Image in
                guard let data = dataResponse.data else {
                    throw URLError(.badServerResponse)
                }
                guard let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                return Image(uiImage: uiImage)
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

//    func fetchArtist(artistId: Int) -> AnyPublisher<ArtistData, Error> {
//        // todo
//    }
}
