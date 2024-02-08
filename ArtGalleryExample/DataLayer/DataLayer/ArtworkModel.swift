//
//  ArtworkModel.swift
//  ArtGalleryExample
//
//  Created by francisco on 02/02/2024.
//

import Foundation

public struct ArtworkResponse: Codable {
    public let pagination: Pagination
    public let artworksData: [Artwork]
    
    enum CodingKeys: String, CodingKey {
        case pagination
        case artworksData = "data"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
        artworksData = try container.decode([Artwork].self, forKey: .artworksData)
    }
    
    init(pagination: Pagination,
         artworksData: [Artwork]) {
        self.pagination = pagination
        self.artworksData = artworksData
    }
}

public struct Pagination: Codable {
    public let total: Int
    public let limit: Int
    public let offset: Int
    public let totalPages: Int
    public let currentPage: Int
    public let nextURL: String

    enum CodingKeys: String, CodingKey {
        case total, limit, offset
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case nextURL = "next_url"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        limit = try container.decode(Int.self, forKey: .limit)
        offset = try container.decode(Int.self, forKey: .offset)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        currentPage = try container.decode(Int.self, forKey: .currentPage)
        nextURL = try container.decode(String.self, forKey: .nextURL)
    }
    
    init(total: Int,
         limit: Int, offset: Int,
         totalPages: Int,
         currentPage: Int,
         nextURL: String) {
            self.total = total
            self.limit = limit
            self.offset = offset
            self.totalPages = totalPages
            self.currentPage = currentPage
            self.nextURL = nextURL
        }
}

public struct Artwork: Codable {
    public let id: Int
    public let title: String
    public let artistDisplay: String?
    public let dateDisplay: String?
    public let mediumDisplay: String?
    public let description: String?
    public let imageID: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case artistDisplay = "artist_display"
        case dateDisplay = "date_display"
        case mediumDisplay = "medium_display"
        case description
        case imageID = "image_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        artistDisplay = try container.decode(String?.self, forKey: .artistDisplay)
        dateDisplay = try container.decode(String?.self, forKey: .dateDisplay)
        mediumDisplay = try container.decode(String?.self, forKey: .mediumDisplay)
        description = try container.decode(String?.self, forKey: .description)
        imageID = try container.decodeIfPresent(String.self, forKey: .imageID)
    }
    
    init(id: Int,
         title: String,
         artistDisplay: String?,
         dateDisplay: String?,
         mediumDisplay: String?,
         description: String?,
         imageID: String?) {
        self.id = id
        self.title = title
        self.artistDisplay = artistDisplay
        self.dateDisplay = dateDisplay
        self.mediumDisplay = mediumDisplay
        self.description = description
        self.imageID = imageID
    }
}

