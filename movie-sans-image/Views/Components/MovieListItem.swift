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
        NeubrutalContainerView(backgroundColor: .secondaryColor, borderColor: Color.primaryColor, shadowStyle: .large) {
            HStack {
                Text(movie.title)
                    .font(.custom("Futura", size: 18))
                    .padding()
                    .lineLimit(1)

                Spacer()

                Button(action: toggleWatchlist) {
                    Image(systemName: isInWatchlist ? "checkmark" : "plus")
                        .foregroundStyle(Color.tertiaryColor)
                        .fontWeight(.bold)
                }
                .sensoryFeedback(.impact(weight: .heavy), trigger: isInWatchlist)
                .padding()
            }
            .padding(.vertical, 6)
            .onTapGesture(perform: onSelect)
            .accessibility(addTraits: .isButton)
            .accessibilityIdentifier("MovieListItem")
        }
        .listRowBackground(Color.backgroundColor)
    }
}
