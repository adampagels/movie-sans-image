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

    func initializeWatchlistStatus(watchlist: [WatchlistEntity]) {
        latestMovies = latestMovies.map { mov in
            var movieToBeToggled = mov
            movieToBeToggled.isInWatchlist = watchlist.contains(where: { $0.id == movieToBeToggled.id })
            return movieToBeToggled
        }
    }

    func toggleWatchlistStatus(movieID: Int) {
        guard let index = latestMovies.firstIndex(where: { $0.id == movieID }) else { return }
        if latestMovies[index].isInWatchlist == false {
            latestMovies[index].isInWatchlist = true
        }
    }

    @MainActor
    func loadPopularMovies() async {
        do {
            latestMovies = try await apiService.fetchPopularMovies()
        } catch let error as APIError {
            networkError = error.localizedDescription
        } catch {
            networkError = "Something went wrong. Please try again"
        }
    }
}
