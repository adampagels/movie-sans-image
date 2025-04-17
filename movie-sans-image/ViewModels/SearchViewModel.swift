//
//  SearchViewModel.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-17.
//

import SwiftUI

@Observable
class SearchViewModel {
    private let apiService: APIServiceProtocol
    var searchText: String = ""
    var searchedMovies: [Movie] = []

    var networkError: String = ""

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    @MainActor
    func searchMovies() async {
        do {
            searchedMovies = try await apiService.searchMovies(by: searchText)
        } catch let error as APIError {
            networkError = error.localizedDescription
        } catch {
            networkError = "Something went wrong. Please try again"
        }
    }
}
