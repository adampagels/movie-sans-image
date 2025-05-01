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
    var loadingState = LoadingState<[Movie]>.idle
    var selectedMovie: Movie?
    var selectedCategory: MovieListCategory = .popular

    init(apiService: APIServiceProtocol, movieWatchlistStatusService: MovieWatchlistStatusServiceProtocol) {
        self.apiService = apiService
        self.movieWatchlistStatusService = movieWatchlistStatusService
    }

    func initializeWatchlistStatus(watchlist: [WatchlistEntity]) {
        if case var .loaded(movies) = loadingState {
            movies = movieWatchlistStatusService.addWatchListStatus(to: movies, watchlist: watchlist)
            loadingState = .loaded(movies)
        }
    }

    func toggleWatchlistStatus(movieID: Int) {
        if case var .loaded(movies) = loadingState {
            movies = movieWatchlistStatusService.toggleWatchlistFlag(for: movieID, movies: movies)
            loadingState = .loaded(movies)
        }
    }

    @MainActor
    func getMovies() async {
        loadingState = .loading
        do {
            let movies = try await apiService.fetchMovies(by: selectedCategory)
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 second delay to prevent UI flash
            loadingState = .loaded(movies)
        } catch let error as APIError {
            loadingState = .failed(error.localizedDescription)
        } catch {
            loadingState = .failed("Something went wrong. Please try again")
        }
    }
}
