//
//  APIService.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

import Foundation

class APIService: APIServiceProtocol {
    private let baseURL: URL

    init(baseURL: URL = URL(string: "https://api.themoviedb.org/3")!) {
        self.baseURL = baseURL
    }

    private func requestMovies(from url: URL) async throws -> [Movie] {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Config.apiKey)",
        ]

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedResponse = try decoder.decode(APIResponse.self, from: data)
        return decodedResponse.results
    }

    func fetchMovies(by category: MovieListCategory) async throws -> [Movie] {
        let fetchMoviesURL = baseURL.appendingPathComponent("/movie/\(category.categoryInSnakeCase)")
        return try await requestMovies(from: fetchMoviesURL)
    }

    func searchMovies(by text: String) async throws -> [Movie] {
        var searchMoviesURL = baseURL.appendingPathComponent("/search/movie")
        searchMoviesURL.append(queryItems: [URLQueryItem(name: "query", value: text)])

        return try await requestMovies(from: searchMoviesURL)
    }

    func discoverMovies(with genreID: String) async throws -> [Movie] {
        var discoverMoviesURL = baseURL.appendingPathComponent("/discover/movie")
        discoverMoviesURL.append(queryItems: [URLQueryItem(name: "with_genres", value: genreID)])

        return try await requestMovies(from: discoverMoviesURL)
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL is invalid, please try again"
        case .invalidResponse: return "Response was invalid. please try again"
        case .invalidData: return "Data was invalid. please try again"
        }
    }
}
