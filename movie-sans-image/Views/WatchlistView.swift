//
//  MyListView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-06.
//

import SwiftUI

struct WatchlistView: View {
    @Environment(WatchlistViewModel.self) private var watchlistViewModel

    var body: some View {
        Text("My List View")
        List {
            ForEach(watchlistViewModel.watchlist) { watchlistItem in
                Text(watchlistItem.title ?? "")
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: watchlistViewModel.removeFromWatchlist)
        }
    }
}

#Preview {
    WatchlistView()
}
