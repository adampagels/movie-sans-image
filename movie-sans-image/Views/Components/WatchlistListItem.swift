//
//  WatchlistItem.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-25.
//

import SwiftUI

struct WatchlistListItem: View {
    @ObservedObject var movie: WatchlistEntity
    let toggleWatched: () -> Void
    let removeFromWatchlist: () -> Void
    let onSelect: (WatchlistEntity) -> Void

    var body: some View {
        NeubrutalContainerView(backgroundColor: .secondaryColor, borderColor: Color.primaryColor, shadowStyle: .large) {
            HStack {
                Button(action: {
                    toggleWatched()
                }) {
                    Image(systemName: movie.isWatched ? "checkmark.square.fill" : "square")
                        .imageScale(.large)
                        .foregroundStyle(Color.tertiaryColor)
                }
                .sensoryFeedback(.impact(weight: .heavy), trigger: movie.isWatched)
                .padding()
                .buttonStyle(.plain)

                Text(movie.title)
                    .strikethrough(movie.isWatched)
                    .font(.custom("Futura", size: 18))
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
