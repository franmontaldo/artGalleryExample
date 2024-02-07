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


/**
 * Protocol to use in dependency injection
 *
 * To use the service you must add it to your class via injection as follows:
 * Example:
 *   ````
 *   let service: ArtAPIServiceProtocol
 *
 *   init(service: ArtAPIServiceProtocol = ArtAPIService()) {
 *       self.service = service
 *   }
 *   ````
 */
protocol ArtAPIServiceProtocol {
    func fetchArtworks(page: Int, limit: Int, completion: @escaping (Result<[Artwork], Error>) -> Void)
    func fetchArtist(artistId: Int,
                     completion: @escaping (Result<ArtistData, Error>) -> Void)
    func fetchArtworkImage(withID imageID: String,
                           completion: @escaping (Image?) -> Void)
}

class ArtAPIService: ArtAPIServiceProtocol {
    private let sessionManager: Session
    
    init(sessionManager: Session = .default) {
        self.sessionManager = sessionManager
    }
    
    func fetchArtworks(page: Int, limit: Int, completion: @escaping (Result<[Artwork], Error>) -> Void) {
        let url = Endpoint.baseURL.rawValue + "artworks"
        let parameters: [String: Any] = ["page": page, "limit": limit]
        
        sessionManager.request(url, parameters: parameters).responseDecodable(of: ArtworkResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchArtist(artistId: Int,
                     completion: @escaping (Result<ArtistData, Error>) -> Void) {
        let url = Endpoint.baseURL.rawValue + "artists/\(artistId)"
        sessionManager.request(url).responseDecodable(of: ArtistData.self) { response in
            switch response.result {
            case .success(let artist):
                completion(.success(artist))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchArtworkImage(withID imageID: String, completion: @escaping (Image?) -> Void) {
        let imageURL = "https://www.artic.edu/iiif/2/\(imageID)/full/843,/0/default.jpg"
        sessionManager.request(imageURL).responseData { response in
            switch response.result {
            case .success(let data):
                if let uiImage = UIImage(data: data) {
                    let image = Image(uiImage: uiImage)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching image: \(error)")
                completion(nil)
            }
        }
    }
}
