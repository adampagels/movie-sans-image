//
//  APIError.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-09-10.
//

import SwiftUI

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
