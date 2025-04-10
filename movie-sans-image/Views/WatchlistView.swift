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
        Text("My List View")
        List {
            ForEach(watchlistViewModel.watchlist) { watchlistItem in
                HStack {
                    Button(action: {
                        watchlistViewModel.markAsWatched(entity: watchlistItem)
                    }) {
                        Image(systemName: watchlistItem.isWatched ? "circle.fill" : "circle")
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)

                    Text(watchlistItem.title ?? "")
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding()
                        .border(Color.purple, width: 4)
                        .strikethrough(watchlistItem.isWatched)
                }
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: watchlistViewModel.removeFromWatchlist)
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    WatchlistView(watchlistViewModel: WatchlistViewModel())
}
