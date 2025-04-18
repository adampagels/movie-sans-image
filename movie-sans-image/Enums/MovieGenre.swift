//
//  Genre.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-18.
//

import SwiftUI

enum MovieGenre: String, CaseIterable {
    case action = "Action"
    case adventure = "Adventure"
    case animation = "Animation"
    case comedy = "Comedy"
    case crime = "Crime"
    case documentary = "Documentary"
    case drama = "Drama"
    case family = "Family"
    case fantasy = "Fantasy"
    case history = "History"
    case horror = "Horror"
    case music = "Musical"
    case mystery = "Mystery"
    case romance = "Romance"
    case scienceFiction = "Science Fiction"
    case tvMovie = "TV Movie"
    case thriller = "Thriller"
    case war = "War"
    case western = "Western"

    var id: Int {
        switch self {
        case .action: return 28
        case .adventure: return 12
        case .animation: return 16
        case .comedy: return 35
        case .crime: return 80
        case .documentary: return 99
        case .drama: return 18
        case .family: return 10751
        case .fantasy: return 14
        case .history: return 36
        case .horror: return 27
        case .music: return 10402
        case .mystery: return 9648
        case .romance: return 10749
        case .scienceFiction: return 878
        case .tvMovie: return 10770
        case .thriller: return 53
        case .war: return 10752
        case .western: return 37
        }
    }

    var backgroundColor: Color {
        switch self {
        case .action: return Color.red
        case .adventure: return Color.orange
        case .animation: return Color.yellow
        case .comedy: return Color.blue
        case .crime: return Color(red: 0.5, green: 0.0, blue: 0.0) // Custom dark red
        case .documentary: return Color.gray
        case .drama: return Color.purple
        case .family: return Color.green
        case .fantasy: return Color.teal
        case .history: return Color.brown
        case .horror: return Color.black
        case .music: return Color.pink
        case .mystery: return Color.indigo // Standard SwiftUI color
        case .romance: return Color.pink // Different shade of pink for romance
        case .scienceFiction: return Color.cyan // Sci-fi often uses cyan
        case .tvMovie: return Color(white: 0.9) // Light gray
        case .thriller: return Color(red: 0.0, green: 0.4, blue: 0.0) // Custom dark green
        case .war: return Color(red: 0.5, green: 0.25, blue: 0.0) // Custom dark brown
        case .western: return Color(red: 0.76, green: 0.61, blue: 0.42) // Sandy brown
        }
    }
}
