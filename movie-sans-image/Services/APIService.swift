//
//  APIService.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

import Foundation

class APIService: APIServiceProtocol {
    private let baseURL: URL

    init(baseURL: URL = URL(string: "https://tmdb-proxy.movie-sans-image-proxy.workers.dev/api")!) {
        self.baseURL = baseURL
    }

    private func requestMovies(from url: URL) async throws -> [Movie] {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "X-App-Secret": Config.appSecret,
        ]

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200 ..< 300:
                do {
                    let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    return decodedResponse.results
                } catch {
                    throw APIError.failedToDecode
                }

            case 400 ..< 500:
                throw APIError.clientError
            case 500 ..< 600:
                throw APIError.serverError
            default:
                throw APIError.invalidResponse
            }

        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .dataNotAllowed, .internationalRoamingOff, .timedOut:
                throw APIError.connectionFailed
            case .badURL, .unsupportedURL:
                throw APIError.invalidURL
            default:
                throw APIError.underlying(urlError)
            }
        }
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
    case connectionFailed
    case clientError
    case serverError
    case invalidResponse
    case invalidData
    case failedToDecode
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Something went wrong with the request.\nPlease try again later."
        case .connectionFailed:
            return "We couldn't connect to the internet.\nPlease check your connection and try again."
        case .clientError:
            return "There was an issue with your request.\nPlease try again."
        case .serverError:
            return "Our servers are having trouble right now.\nPlease try again shortly."
        case .invalidResponse:
            return "We received an unexpected response.\nPlease try again later."
        case .invalidData:
            return "Something went wrong while processing the data.\nPlease try again."
        case .failedToDecode:
            return "We couldn’t read the information properly.\nPlease try again later."
        case let .underlying(error):
            return error.localizedDescription
        }
    }
}
