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
            VStack(alignment: .leading, spacing: 16) {
                Text("\(movie.title)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .accessibilityIdentifier("DetailViewMovieTitle")

                HStack {
                    if movie.vote_count ?? 0 > 0 {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.tertiaryColor)
                                .fontWeight(.bold)

                            Text("\(movie.vote_average ?? 0, specifier: "%.1f")/10")
                            Text("(\(movie.vote_count ?? 0) reviews)")
                        }
                    }

                    Spacer()
                }

                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.tertiaryColor)
                        .fontWeight(.bold)
                    Text(movie.release_date ?? "")
                }
                Text(movie.overview ?? "")
                    .font(.headline)
                Spacer()
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("DetailViewSheet")
            .padding()
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
            release_date: "2000-01-01",
            title: "Novocaine",
            video: false,
            vote_average: 8.0,
            vote_count: 6,
            isInWatchlist: false
        )
    )
}
