//
//  WatchlistItem.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-25.
//

import SwiftUI

struct WatchlistListItem: View {
    let movie: WatchlistEntity
    let isWatched: Bool
    let toggleWatched: () -> Void
    let removeFromWatchlist: () -> Void
    let onSelect: (WatchlistEntity) -> Void

    var body: some View {
        NeubrutalContainerView(backgroundColor: .secondaryColor, borderColor: Color.primaryColor) {
            HStack {
                Button(action: {
                    toggleWatched()
                }) {
                    Image(systemName: isWatched ? "checkmark.square.fill" : "square")
                        .imageScale(.large)
                        .foregroundStyle(Color.tertiaryColor)
                }
                .sensoryFeedback(.impact(weight: .heavy), trigger: isWatched)
                .padding()
                .buttonStyle(.plain)

                Text(movie.title)
                    .strikethrough(isWatched)
            }
            .onTapGesture {
                onSelect(movie)
            }
            .accessibility(addTraits: .isButton)
            .accessibilityIdentifier("WatchlistListItem")
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(.bottom)
        .swipeActions(allowsFullSwipe: true) {
            Button(role: .destructive) {
                removeFromWatchlist()
            } label: {
                Image(systemName: "xmark")
            }
            .accessibilityIdentifier("SwipeToDeleteButton")
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.backgroundColor)
    }
}
