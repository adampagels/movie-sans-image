//
//  MockAPIService.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-06.
//

import CoreData
@testable import movie_sans_image
import Testing

class MockAPIService: APIServiceProtocol {
    private var movieResults: [Movie]

    init(movieResults: [Movie] = []) {
        self.movieResults = movieResults
    }

    func discoverMovies(with _: String) async throws -> [Movie] {
        return movieResults
    }

    func fetchMovies(by _: MovieListCategory) async throws -> [Movie] {
        return movieResults
    }

    func searchMovies(by _: String) async throws -> [Movie] {
        return movieResults
    }
}
