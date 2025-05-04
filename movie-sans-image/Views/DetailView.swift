//
//  DetailView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-11.
//

import SwiftUI

struct DetailView: View {
    var movie: MovieDetailsDisplayable
    var body: some View {
        ZStack {
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text(movie.title)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .accessibilityIdentifier("DetailViewMovieTitle")
                Text(movie.overview ?? "")
                    .font(.headline)
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("DetailViewSheet")
            .padding()
        }
    }
}

#Preview() {
    DetailView(
        movie: Movie(
            adult: false,
            backdrop_path: nil,
            genre_ids: nil,
            id: 1_195_506,
            original_language: nil,
            original_title: nil,
            overview: "When the girl of his dreams is kidnapped, everyman Nate turns his inability to feel pain into an unexpected strength in his fight to get her back.",
            popularity: 482.0451,
            poster_path: "../img",
            release_date: "01 -01 -2000",
            title: "Novocaine",
            video: false,
            vote_average: 8,
            vote_count: 6,
            isInWatchlist: false
        )
    )
}
