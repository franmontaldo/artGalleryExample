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
    func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [Artwork], pagination: Pagination), Error>
    func fetchArtworkImage(withID imageID: String) -> AnyPublisher<Image, Error>
    func pushArtworks(_ artworks: [Artwork])
    func pushArtworkImage(imageID: String, imageData: Data)
    func updateArtworks(with newArtworks: [Artwork])
}

public class StorageService: StorageServiceProtocol {
    private static var persistentContainer: NSPersistentContainer = {
        let momdName = "StorageDataModel"
        guard let modelURL = Bundle(for: StorageService.self).url(forResource: "StorageDataModel", withExtension:"momd") else {
                fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let container = NSPersistentContainer(name: momdName, managedObjectModel: mom)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    public init() { }
    
    public func fetchArtworks(page: Int, limit: Int) -> AnyPublisher<(artworks: [Artwork], pagination: Pagination), Error> {
        let managedContext = StorageService.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ArtworkDataEntity> = ArtworkDataEntity.fetchRequest()
        let offset = (page - 1) * limit
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = offset
        
        return Future<(artworks: [Artwork], pagination: Pagination), Error> { promise in
            do {
                let artworkEntities = try managedContext.fetch(fetchRequest)
                let artworks = artworkEntities.map { artworkEntity in
                    Artwork(id: Int(artworkEntity.id),
                            title: artworkEntity.title ?? "",
                            artistDisplay: artworkEntity.artistDisplay,
                            dateDisplay: artworkEntity.dateDisplay,
                            mediumDisplay: artworkEntity.mediumDisplay,
                            description: artworkEntity.descriptionDisplay,
                            imageID: artworkEntity.imageID)
                }
                let totalArtworksCount = try managedContext.count(for: ArtworkDataEntity.fetchRequest())
                let totalPages = Int(ceil(Double(totalArtworksCount) / Double(limit)))
                let currentPage = page
                let nextPage = page + 1
                let nextURL = Endpoint.baseURL.rawValue + "artworks?page=\(nextPage))&limit=\(limit)"
                let pagination = Pagination(total: totalArtworksCount,
                                            limit: limit,
                                            offset: offset,
                                            totalPages: totalPages,
                                            currentPage: currentPage,
                                            nextURL: nextURL)
                promise(.success((artworks: artworks, pagination: pagination)))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func fetchArtworkImage(withID imageID: String) -> AnyPublisher<Image, Error> {
        let managedContext = StorageService.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ImageDataEntity> = ImageDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageID == %@", imageID)
        
        return Future<Image, Error> { promise in
            do {
                let imageEntities = try managedContext.fetch(fetchRequest)
                guard let imageEntity = imageEntities.first else {
                    throw NSError(domain: "com.franmontaldo.ArtGalleryExample.error",
                                  code: 404,
                                  userInfo: [NSLocalizedDescriptionKey: "Image not found"])
                }
                guard let imageData = imageEntity.imageData,
                      let uiImage = UIImage(data: imageData) else {
                    throw NSError(domain: "com.franmontaldo.ArtGalleryExample.error",
                                  code: 500,
                                  userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to image"])
                }
                promise(.success(Image(uiImage: uiImage)))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func pushArtworks(_ artworks: [Artwork]) {
        let managedContext = StorageService.persistentContainer.viewContext
        artworks.forEach { artwork in
            let artworkEntity = ArtworkDataEntity(context: managedContext)
            artworkEntity.id = Int32(artwork.id)
            artworkEntity.title = artwork.title
            artworkEntity.artistDisplay = artwork.artistDisplay
            artworkEntity.dateDisplay = artwork.dateDisplay
            artworkEntity.mediumDisplay = artwork.mediumDisplay
            artworkEntity.descriptionDisplay = artwork.description
            artworkEntity.imageID = artwork.imageID
        }
        do {
            try managedContext.save()
        } catch {
            print("Error saving artworks: \(error)")
        }
    }
    
    
    public func pushArtworkImage(imageID: String, imageData: Data) {
        let managedContext = StorageService.persistentContainer.viewContext
        let imageEntity = ImageDataEntity(context: managedContext)
        imageEntity.imageID = imageID
        imageEntity.imageData = imageData
        do {
            try managedContext.save()
        } catch {
            print("Error saving artwork image with ID \(imageID): \(error)")
        }
    }
    
    public func updateArtworks(with newArtworks: [Artwork]) {
        let managedContext = StorageService.persistentContainer.viewContext
        do {
            let existingArtworksFetchRequest: NSFetchRequest<ArtworkDataEntity> = ArtworkDataEntity.fetchRequest()
            let existingArtworks = try managedContext.fetch(existingArtworksFetchRequest)
            var existingArtworkDict: [Int: ArtworkDataEntity] = [:]
            for artworkEntity in existingArtworks {
                existingArtworkDict[Int(artworkEntity.id)] = artworkEntity
            }
            for artwork in newArtworks {
                if let existingArtworkEntity = existingArtworkDict[artwork.id] {
                    existingArtworkEntity.title = artwork.title
                    existingArtworkEntity.artistDisplay = artwork.artistDisplay
                    existingArtworkEntity.dateDisplay = artwork.dateDisplay
                    existingArtworkEntity.mediumDisplay = artwork.mediumDisplay
                    existingArtworkEntity.descriptionDisplay = artwork.description
                    existingArtworkEntity.imageID = artwork.imageID
                } else {
                    let newArtworkEntity = ArtworkDataEntity(context: managedContext)
                    newArtworkEntity.id = Int32(artwork.id)
                    newArtworkEntity.title = artwork.title
                    newArtworkEntity.artistDisplay = artwork.artistDisplay
                    newArtworkEntity.dateDisplay = artwork.dateDisplay
                    newArtworkEntity.mediumDisplay = artwork.mediumDisplay
                    newArtworkEntity.descriptionDisplay = artwork.description
                    newArtworkEntity.imageID = artwork.imageID
                }
            }
            let newArtworkIDs = Set(newArtworks.map { $0.id })
            for artworkEntity in existingArtworks {
                if !newArtworkIDs.contains(Int(artworkEntity.id)) {
                    managedContext.delete(artworkEntity)
                }
            }
            try managedContext.save()
        } catch {
            print("Error updating artworks: \(error)")
        }
    }
}
