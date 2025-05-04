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
        .toolbar {
            ThemeButton()
        }
    }
}

#Preview {
    NavigationStack {
        WatchlistView(watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService()))
            .listRowBackground(Color.backgroundColor)
    }
}
