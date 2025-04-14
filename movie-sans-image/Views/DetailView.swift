//
//  DetailView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-11.
//

import SwiftUI

struct DetailView: View {
    var movie: Movie
    var body: some View {
        VStack {
            Text(movie.title)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            Text(movie.overview ?? "")
                .font(.headline)
        }
        .padding()
    }
}

#Preview() {
    DetailView(movie: Movie(
        adult: false,
        backdrop_path: nil,
        genre_ids: nil,
        id: 1_195_506,
        original_language: nil,
        original_title: nil,
        overview: Optional(
            "When the girl of his dreams is kidnapped, everyman Nate turns his inability to feel pain into an unexpected strength in his fight to get her back."
        ),
        popularity: 482.0451,
        poster_path: nil,
        release_date: nil,
        title: "Novocaine",
        video: false,
        vote_average: nil,
        vote_count: nil,
        isInWatchlist: Optional(false)
    ))
}
