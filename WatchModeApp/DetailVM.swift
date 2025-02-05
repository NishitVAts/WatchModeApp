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


