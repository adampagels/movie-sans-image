//
//  MovieList.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-24.
//

import SwiftUI

struct MovieList: View {
    let movies: [Movie]
    let toggleWatchlist: (Movie) -> Void
    let onSelect: (Movie) -> Void

    var body: some View {
        ForEach(movies, id: \.id) { movie in
            MovieListItem(
                movie: movie,
                isInWatchlist: movie.isInWatchlist ?? false,
                toggleWatchlist: {
                    toggleWatchlist(movie)
                },
                onSelect: {
                    onSelect(movie)
                }
            )
            .padding(.vertical, 10)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.backgroundColor)
        }
    }
}
