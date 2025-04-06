//
//  APIServiceProtocol.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

protocol APIServiceProtocol {
    func fetchPopularMovies() async throws -> [Movie]
}
