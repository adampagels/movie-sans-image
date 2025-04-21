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
    private let movieWatchlistStatusService: MovieWatchlistStatusServiceProtocol
    var searchText: String = ""
    var movies: [Movie] = []
    var networkError: String = ""
    var selectedMovie: Movie?

    var shouldShowGenreList: Bool {
        movies.isEmpty
    }

    init(apiService: APIServiceProtocol, movieWatchlistStatusService: MovieWatchlistStatusServiceProtocol) {
        self.apiService = apiService
        self.movieWatchlistStatusService = movieWatchlistStatusService
    }

    func initializeWatchlistStatus(watchlist: [WatchlistEntity]) {
        movies = movieWatchlistStatusService.addWatchListStatus(to: movies, watchlist: watchlist)
    }

    func toggleWatchlistStatus(movieID: Int) {
        movies = movieWatchlistStatusService.toggleWatchlistFlag(for: movieID, movies: movies)
    }

    @MainActor
    func searchMovies() async {
        do {
            movies = try await apiService.searchMovies(by: searchText)
        } catch let error as APIError {
            networkError = error.localizedDescription
        } catch {
            networkError = "Something went wrong. Please try again"
        }
    }
}
