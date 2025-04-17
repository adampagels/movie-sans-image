//
//  MovieListCategory.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-17.
//

enum MovieListCategory: String, CaseIterable {
    case popular = "Popular"
    case nowPlaying = "Now Playing"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"

    var categoryInSnakeCase: String {
        switch self {
        case .popular: "popular"
        case .nowPlaying: "now_playing"
        case .topRated: "top_rated"
        case .upcoming: "upcoming"
        }
    }
}
