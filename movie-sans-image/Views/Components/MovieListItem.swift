//
//  MovieListItem.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-24.
//

import SwiftUI

struct MovieListItem: View {
    let movie: Movie
    let isInWatchlist: Bool
    let toggleWatchlist: () -> Void
    let onSelect: () -> Void

    var body: some View {
        NeubrutalContainerView(backgroundColor: .secondaryColor) {
            HStack {
                Text(movie.title)
                    .padding()

                Spacer()

                Button(action: toggleWatchlist) {
                    Image(systemName: isInWatchlist ? "checkmark" : "plus")
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                }
                .padding()
                .contentTransition(.symbolEffect(.replace))
            }
            .onTapGesture(perform: onSelect)
            .accessibility(addTraits: .isButton)
            .accessibilityIdentifier("MovieListItem")
        }
    }
}
