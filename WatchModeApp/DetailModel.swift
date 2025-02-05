//
//  DetailModel.swift
//  WatchModeApp
//
//  Created by Nishit Vats on 05/02/25.
//

import Foundation

struct TitleDetailModel: Decodable {
    let id: Int
    let title: String
    let year: Int?
    let plotOverview: String?
    let userRating: Double?
    let poster: String?
    let genres: [Int]?
    let sources: [StreamingSource]?
    let genreNames:[String]?

    enum CodingKeys: String, CodingKey {
        case id, title, year, poster, genres, sources
        case plotOverview = "plot_overview"
        case userRating = "user_rating"
        case genreNames = "genre_names"
    }
}

struct StreamingSource: Decodable {
    let id: Int
    let name: String
    let logo100px: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logo100px = "logo_100px"
    }
}
