//
//  MovieViewModel.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-04.
//

import SwiftUI

@Observable
class MovieViewModel {
    private let apiService: APIServiceProtocol
    var latestMovies: [Movie] = []
    var networkError: String = ""

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    @MainActor
    func loadPopularMovies() async {
        do {
            latestMovies = try await apiService.fetchPopularMovies()
            print("latestMovies", latestMovies)
        } catch let error as APIError {
            networkError = error.localizedDescription
        } catch {
            networkError = "Something went wrong. Please try again"
        }
    }
}
