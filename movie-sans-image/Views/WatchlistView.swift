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
        ZStack {
            if watchlistViewModel.watchlist.isEmpty {
                EmptyStateView(
                    title: "Nothing to watch!",
                    subtitle: "Add to your watchlist and never miss out."
                )
            } else {
                List {
                    WatchlistList(
                        movies: watchlistViewModel.watchlist,
                        toggleWatched: { (movie: WatchlistEntity) in
                            watchlistViewModel.markAsWatched(entity: movie)
                        },
                        removeFromWatchlist: { (movieID: Int) in
                            watchlistViewModel.removeFromWatchlist(movieID: movieID)
                        },
                        onSelect: { movie in
                            watchlistViewModel.selectedMovie = movie
                        }
                    )
                }
                .listStyle(PlainListStyle())
                .sheet(item: $watchlistViewModel.selectedMovie) { movie in
                    DetailView(movie: movie)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ThemeButton()
        }
        .navigationTitle("Watchlist")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        WatchlistView(watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService()))
            .listRowBackground(Color.backgroundColor)
    }
}
