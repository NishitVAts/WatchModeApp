//
//  DetailScreen.swift
//  WatchModeApp
//
//  Created by Nishit Vats on 04/02/25.
//


import Foundation
import Combine

class TitleService {
    private let baseURL = "https://api.watchmode.com/v1/list-titles/"
    private let apiKey = "VIgyfCH4jYMtwOwtXXhshaM8HSvgoEzUbIUj4GB0"

    func fetchMoviesAndShows() -> AnyPublisher<([TitleModel], [TitleModel]), Error> {
        // Create URLs for separate API calls
        let moviesURL = URL(string: "\(baseURL)?apiKey=\(apiKey)&types=movie&regions=US&source_types=sub&sort_by=popularity_desc")!
        let tvShowsURL = URL(string: "\(baseURL)?apiKey=\(apiKey)&types=tv_series&regions=US&source_types=sub&sort_by=popularity_desc")!

        // Create publishers for both API calls
        let moviesPublisher = URLSession.shared.dataTaskPublisher(for: moviesURL)
            .map(\.data)
            .decode(type: TitleResponse.self, decoder: JSONDecoder())
            .map { $0.titles }
            .eraseToAnyPublisher()

        let tvShowsPublisher = URLSession.shared.dataTaskPublisher(for: tvShowsURL)
            .map(\.data)
            .decode(type: TitleResponse.self, decoder: JSONDecoder())
            .map { $0.titles }
            .eraseToAnyPublisher()

        // Use Publishers.Zip to combine results
        return Publishers.Zip(moviesPublisher, tvShowsPublisher)
            .eraseToAnyPublisher()
    }
}



class TitleViewModel: ObservableObject {
    @Published var movies: [TitleModel] = []
    @Published var tvShows: [TitleModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let titleService = TitleService()

    func fetchTitles() {
        isLoading = true

        titleService.fetchMoviesAndShows()
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if case let .failure(error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { (movies, tvShows) in
                DispatchQueue.main.async {
                    self.movies = movies
                    self.tvShows = tvShows
                }
            })
            .store(in: &cancellables)
    }
}
