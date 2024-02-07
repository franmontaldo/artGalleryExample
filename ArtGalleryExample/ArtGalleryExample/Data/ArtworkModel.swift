//
//  ArtworkModel.swift
//  ArtGalleryExample
//
//  Created by francisco on 02/02/2024.
//

import Foundation

struct ArtworkResponse: Codable {
    let pagination: Pagination
    let data: [Artwork]
    
    enum CodingKeys: String, CodingKey {
        case pagination
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
        data = try container.decode([Artwork].self, forKey: .data)
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
    let thumbnail: Thumbnail?
    let imageID: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case artistDisplay = "artist_display"
        case dateDisplay = "date_display"
        case mediumDisplay = "medium_display"
        case description
        case thumbnail
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
        thumbnail = try container.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        imageID = try container.decodeIfPresent(String.self, forKey: .imageID)
    }
}

struct Thumbnail: Codable {
    let lqip: String
    let width: Int
    let height: Int
    let altText: String?

    enum CodingKeys: String, CodingKey {
        case lqip, width, height
        case altText = "alt_text"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lqip = try container.decode(String.self, forKey: .lqip)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        altText = try container.decode(String?.self, forKey: .altText)
    }
}
