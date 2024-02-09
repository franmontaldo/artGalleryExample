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

public protocol ArtAPIServiceProtocol {
    func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [Artwork], pagination: Pagination), Error>
    func fetchArtworkImage(withID imageID: String) -> AnyPublisher<(Image, Data), Error>
    func checkServerReachability(completion: @escaping (Bool, Error?) -> Void) 
}

public class ArtAPIService: ArtAPIServiceProtocol {
    private let session: Session
    
    public init(session: Session = .default) {
        self.session = session
    }
    
    public func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [Artwork], pagination: Pagination), Error> {
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
    
    
    public func fetchArtworkImage(withID imageID: String) -> AnyPublisher<(Image, Data), Error> {
        let imageURL = Endpoint.imageBaseURL.rawValue + "\(imageID)/full/400,/0/default.jpg"
        return session
            .request(imageURL)
            .publishData()
            .tryMap { dataResponse -> (Image, Data) in
                guard let data = dataResponse.data else {
                    throw URLError(.badServerResponse)
                }
                guard let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                return (Image(uiImage: uiImage), data)
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func checkServerReachability(completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoint.baseURL.rawValue
        AF.request(url).response { response in
            if let error = response.error {
                completion(false, error)
                return
            }
            if let statusCode = response.response?.statusCode, statusCode >= 200 && statusCode < 400 {
                completion(true, nil)
                return
            }
            completion(false, nil)
            
        }
    }
}
