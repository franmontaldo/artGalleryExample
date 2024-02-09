//
//  StorageService.swift
//  DataLayer
//
//  Created by francisco on 09/02/2024.
//

import Foundation
import Combine
import SwiftUI
import CoreData

public protocol StorageServiceProtocol {
//    func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [Artwork], pagination: Pagination), Error>
//    func fetchArtworkImage(withID imageID: String) -> AnyPublisher<Image, Error>
    func pushArtworks(_ artworks: [Artwork], limit: Int)
    func pushArtworkImage(imageID: String, imageData: Data)
    func refreshStorage()
}

public class StorageService: StorageServiceProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "ArtworksModel")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
    }
    
//    public func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [Artwork], pagination: Pagination), Error> {
//        //<#code#>
//    }
//    
//    public func fetchArtworkImage(withID imageID: String) -> AnyPublisher<Image, Error> {
//        //<#code#>
//    }
    
    public func pushArtworks(_ artworks: [Artwork], limit: Int) {
        //<#code#>
    }
    
    public func pushArtworkImage(imageID: String, imageData: Data) {
        //<#code#>
    }
    
    public func refreshStorage() {
        //<#code#>
    }
}
