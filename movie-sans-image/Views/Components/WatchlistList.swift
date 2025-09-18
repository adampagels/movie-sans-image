//
//  WatchlistList.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-25.
//

import SwiftUI

struct WatchlistList: View {
    let movies: [WatchlistEntity]
    let toggleWatched: (WatchlistEntity) -> Void
    let removeFromWatchlist: (Int) -> Void
    let onSelect: (WatchlistEntity) -> Void

    var body: some View {
        ForEach(movies, id: \.objectID) { movie in
            WatchlistListItem(
                movie: movie,
                toggleWatched: {
                    toggleWatched(movie)
                },
                removeFromWatchlist: {
                    removeFromWatchlist(Int(movie.id))
                },
                onSelect: onSelect
            )
            .listRowSeparator(.hidden)
        }
    }
}
