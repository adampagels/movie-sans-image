//
//  MyListView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-06.
//

import SwiftUI

struct WatchlistView: View {
    @Bindable var watchlistViewModel: WatchlistViewModel

    var body: some View {
        List {
            ForEach(watchlistViewModel.watchlist, id: \.id) { watchlistItem in
                NeubrutalContainerView(backgroundColour: .gray) {
                    HStack {
                        Button(action: {
                            watchlistViewModel.markAsWatched(entity: watchlistItem)
                        }) {
                            Image(systemName: watchlistItem.isWatched ? "checkmark.square.fill" : "square")
                                .imageScale(.large)
                        }
                        .padding()
                        .buttonStyle(.plain)

                        Text(watchlistItem.title ?? "")
                            .strikethrough(watchlistItem.isWatched)
                    }
                    .accessibility(addTraits: .isButton)
                    .accessibilityIdentifier("MovieListItem")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(.bottom)
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        watchlistViewModel.removeFromWatchlist(movieID: Int(watchlistItem.id))
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityIdentifier("SwipeToDeleteButton")
                }
                .tint(.black)
                .listRowSeparator(.hidden)
            }
        }

        .listStyle(PlainListStyle())
        .toolbar {
            ThemeButton()
        }
    }
}

#Preview {
    NavigationStack {
        WatchlistView(watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService()))
    }
}
