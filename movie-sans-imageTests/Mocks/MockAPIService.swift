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
    private var errorToThrow: Error?

    var lastDiscoverQuery: String = ""
    var lastFetchCategory: MovieListCategory = .popular
    var lastSearchQuery: String = ""

    init(movieResults: [Movie] = [], errorToThrow: Error? = nil) {
        self.movieResults = movieResults
        self.errorToThrow = errorToThrow
    }

    func discoverMovies(with query: String) async throws -> [Movie] {
        lastDiscoverQuery = query
        if let error = errorToThrow { throw error }
        return movieResults
    }

    func fetchMovies(by category: MovieListCategory) async throws -> [Movie] {
        lastFetchCategory = category
        if let error = errorToThrow { throw error }
        return movieResults
    }

    func searchMovies(by query: String) async throws -> [Movie] {
        lastSearchQuery = query
        if let error = errorToThrow { throw error }
        return movieResults
    }
}
