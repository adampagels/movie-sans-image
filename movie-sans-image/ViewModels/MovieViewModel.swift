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
    var movies: [Movie] = []
    var networkError: String = ""
    var selectedMovie: Movie?
    var selectedCategory: MovieListCategory = .popular

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func selectCategory(category: MovieListCategory) {
        selectedCategory = category
    }

    func initializeWatchlistStatus(watchlist: [WatchlistEntity]) {
        movies = movies.map { mov in
            var movieToBeToggled = mov
            movieToBeToggled.isInWatchlist = watchlist.contains(where: { $0.id == movieToBeToggled.id })
            return movieToBeToggled
        }
    }

    func toggleWatchlistStatus(movieID: Int) {
        guard let index = movies.firstIndex(where: { $0.id == movieID }) else { return }
        if movies[index].isInWatchlist == false {
            movies[index].isInWatchlist = true
        } else {
            movies[index].isInWatchlist = false
        }
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
