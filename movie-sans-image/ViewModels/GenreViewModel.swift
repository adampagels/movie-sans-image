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
    var movies: [Movie] = []
    var networkError: String = ""

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
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
