//
//  APIServiceProtocol.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

protocol APIServiceProtocol {
    func fetchMovies(by: MovieListCategory) async throws -> [Movie]
    func searchMovies(by: String) async throws -> [Movie]
    func discoverMovies(with: String) async throws -> [Movie]
}
