//
//  GenreViewModel.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-19.
//
import SwiftUI

@Observable
class GenreViewModel {
    private let apiService: APIServiceProtocol
    private let movieWatchlistStatusService: MovieWatchlistStatusServiceProtocol
    var loadingState = LoadingState<[Movie]>.idle
    var selectedMovie: Movie?

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
    func getMoviesByGenreID(genreID: String) async {
        loadingState = .loading
        do {
            let movies = try await apiService.discoverMovies(with: genreID)
            loadingState = .loaded(movies)
        } catch {
            loadingState = .failed(error.localizedDescription)
        }
    }
}
