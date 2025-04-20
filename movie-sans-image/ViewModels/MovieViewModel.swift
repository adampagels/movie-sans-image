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
    private let movieWatchlistStatusService: MovieWatchlistStatusServiceProtocol
    var movies: [Movie] = []
    var networkError: String = ""
    var selectedMovie: Movie?
    var selectedCategory: MovieListCategory = .popular

    init(apiService: APIServiceProtocol, movieWatchlistStatusService: MovieWatchlistStatusServiceProtocol) {
        self.apiService = apiService
        self.movieWatchlistStatusService = movieWatchlistStatusService
    }

    func selectCategory(category: MovieListCategory) {
        selectedCategory = category
    }

    func initializeWatchlistStatus(watchlist: [WatchlistEntity]) {
        movies = movieWatchlistStatusService.addWatchListStatus(to: movies, watchlist: watchlist)
    }

    func toggleWatchlistStatus(movieID: Int) {
        movies = movieWatchlistStatusService.toggleWatchlistFlag(for: movieID, movies: movies)
    }

    @MainActor
    func getMovies() async {
        do {
            movies = try await apiService.fetchMovies(by: selectedCategory)
        } catch let error as APIError {
            networkError = error.localizedDescription
        } catch {
            networkError = "Something went wrong. Please try again"
        }
    }
}
