//
//  ArtworkModel.swift
//  ArtGalleryExample
//
//  Created by francisco on 02/02/2024.
//

import Foundation

struct ArtworkResponse: Codable {
    let pagination: Pagination
    let artworksData: [Artwork]
    
    enum CodingKeys: String, CodingKey {
        case pagination
        case artworksData = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
        artworksData = try container.decode([Artwork].self, forKey: .artworksData)
    }
}

struct Pagination: Codable {
    let total: Int
    let limit: Int
    let offset: Int
    let totalPages: Int
    let currentPage: Int
    let nextURL: String

    enum CodingKeys: String, CodingKey {
        case total, limit, offset
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case nextURL = "next_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        limit = try container.decode(Int.self, forKey: .limit)
        offset = try container.decode(Int.self, forKey: .offset)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        currentPage = try container.decode(Int.self, forKey: .currentPage)
        nextURL = try container.decode(String.self, forKey: .nextURL)
    }
}

struct Artwork: Codable {
    let id: Int
    let title: String
    let artistDisplay: String?
    let dateDisplay: String?
    let mediumDisplay: String?
    let description: String?
    let imageID: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case artistDisplay = "artist_display"
        case dateDisplay = "date_display"
        case mediumDisplay = "medium_display"
        case description
        case imageID = "image_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        artistDisplay = try container.decode(String?.self, forKey: .artistDisplay)
        dateDisplay = try container.decode(String?.self, forKey: .dateDisplay)
        mediumDisplay = try container.decode(String?.self, forKey: .mediumDisplay)
        description = try container.decode(String?.self, forKey: .description)
        imageID = try container.decodeIfPresent(String.self, forKey: .imageID)
    }
}

