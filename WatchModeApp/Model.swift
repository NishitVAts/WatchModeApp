//
//  Model.swift
//  WatchModeApp
//
//  Created by Nishit Vats on 03/02/25.
//

import Foundation




// MARK: - API Response Model


struct TitleResponse: Decodable {
    let titles: [TitleModel]
    let page: Int
    let total_results: Int
    let total_pages: Int
}


// MARK: - Movie & TV Show Model
struct TitleModel: Identifiable, Decodable {
    let id: Int
    let title: String
    let year: Int?
    let imdbID: String?
    let tmdbID: Int?
    let type: String
    let userRating: Double?

    // Coding keys for decoding JSON response
    enum CodingKeys: String, CodingKey {
        case id, title, year, type
        case imdbID = "imdb_id"
        case tmdbID = "tmdb_id"
        case userRating = "user_rating"
    }
}

