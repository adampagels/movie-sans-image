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
    var lastDiscoverQuery: String = ""
    var lastFetchCategory: MovieListCategory = .popular
    var lastSearchQuery: String = ""

    init(movieResults: [Movie] = []) {
        self.movieResults = movieResults
    }

    func discoverMovies(with query: String) async throws -> [Movie] {
        lastDiscoverQuery = query
        return movieResults
    }

    func fetchMovies(by category: MovieListCategory) async throws -> [Movie] {
        lastFetchCategory = category
        return movieResults
    }

    func searchMovies(by query: String) async throws -> [Movie] {
        lastSearchQuery = query
        return movieResults
    }
}
