//
//  Movie.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

import Foundation

struct Movie: Identifiable, Codable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]?
    let id: Int
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let release_date: String?
    let title: String
    let video: Bool
    let vote_average: Double?
    let vote_count: Int?
}

struct APIResponse: Codable {
    let results: [Movie]
}
