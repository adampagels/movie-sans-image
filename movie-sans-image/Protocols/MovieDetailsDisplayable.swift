//
//  MovieDetailsDisplayable.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-04.
//

protocol MovieDetailsDisplayable {
    var adult: Bool { get }
    var backdrop_path: String? { get }
    var id: Int { get }
    var original_language: String? { get }
    var original_title: String? { get }
    var overview: String? { get }
    var popularity: Double { get }
    var poster_path: String? { get }
    var release_date: String? { get }
    var title: String { get }
    var video: Bool { get }
    var vote_average: Double? { get }
    var vote_count: Int? { get }
}
