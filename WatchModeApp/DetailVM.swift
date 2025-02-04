//
//  DetailScreen.swift
//  WatchModeApp
//
//  Created by Nishit Vats on 04/02/25.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    @Published var detail: TitleDetailModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiKey = "VIgyfCH4jYMtwOwtXXhshaM8HSvgoEzUbIUj4GB0"
    private var cancellables = Set<AnyCancellable>()

    func fetchDetail(for titleID: Int) {
        isLoading = true
        let urlString = "https://api.watchmode.com/v1/title/\(titleID)/details/?apiKey=\(apiKey)"
        
        debugPrint(urlString)
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TitleDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            }, receiveValue: { detail in
                self.detail = detail
                print(detail)
            })
            .store(in: &cancellables)
    }
}


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
