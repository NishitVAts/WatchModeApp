//
//  HomeVM .swift
//  WatchModeApp
//
//  Created by Nishit Vats on 03/02/25.
//

import Foundation
import Combine

class TitleService {
    private let baseURL = "https://api.watchmode.com/v1/list-titles/"
    private let apiKey = "VIgyfCH4jYMtwOwtXXhshaM8HSvgoEzUbIUj4GB0"
    var category :category = .both
    func fetchTitles() -> AnyPublisher<TitleResponse, Error> {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // Adding query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "types", value: "\(category.rawValue)"),
            URLQueryItem(name: "regions", value: "US"),
            URLQueryItem(name: "source_types", value: "sub"),
            URLQueryItem(name: "sort_by", value: "popularity_desc")
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TitleResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum category:String,CaseIterable{
    case movie = "movie"
    case tvSeries = "tv_series"
    case both = "movie,tv_series"
}

class TitleViewModel: ObservableObject {
    @Published var titles: [TitleModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var category:category = .both

    private var cancellables = Set<AnyCancellable>()
    private let titleService = TitleService()

    func fetchTitles() {
        isLoading = true
        titleService.category = category
        titleService.fetchTitles()
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if case let .failure(error) = completion {
                        self.errorMessage = error.localizedDescription
                        print(error)
                    }
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.titles = response.titles
                }
            })
            .store(in: &cancellables)
    }
}
