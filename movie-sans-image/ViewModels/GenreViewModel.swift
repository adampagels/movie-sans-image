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
    var movies: [Movie] = []
    var networkError: String = ""
    var selectedMovie: Movie?

    init(apiService: APIServiceProtocol, movieWatchlistStatusService: MovieWatchlistStatusService) {
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
    func getMoviesByGenreID(genreID: String) async {
        do {
            movies = try await apiService.discoverMovies(with: genreID)
        } catch let error as APIError {
            networkError = error.localizedDescription
        } catch {
            networkError = "Something went wrong. Please try again"
        }
    }
}
