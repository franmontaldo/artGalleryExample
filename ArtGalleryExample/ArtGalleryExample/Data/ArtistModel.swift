//
//  ArtistModel.swift
//  ArtGalleryExample
//
//  Created by francisco on 07/02/2024.
//

import Foundation

struct ArtistResponse: Codable {
    let data: ArtistData
}

struct ArtistData: Codable {
    let id: Int
    let apiModel: String
    let apiLink: String
    let title: String
    let sortTitle: String
    let altTitles: [String]?
    let isArtist: Bool
    let birthDate: Int?
    let deathDate: Int?
    let description: String?
    let updatedAt: String
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case apiModel = "api_model"
        case apiLink = "api_link"
        case title = "title"
        case sortTitle = "sort_title"
        case altTitles = "alt_titles"
        case isArtist = "is_artist"
        case birthDate = "birth_date"
        case deathDate = "death_date"
        case description = "description"
        case updatedAt = "updated_at"
        case timestamp = "timestamp"
    }
}
