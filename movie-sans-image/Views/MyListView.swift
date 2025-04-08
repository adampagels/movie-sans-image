//
//  MyListView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-06.
//

import SwiftUI

struct MyListView: View {
    @State var watchlistViewModel = WatchlistViewModel()

    var body: some View {
        Text("My List View")
            .task {
                watchlistViewModel.getWatchlist()
            }
        ScrollView {
            ForEach(watchlistViewModel.watchlist) { watchlistItem in
                Text(watchlistItem.title ?? "")
            }
        }
    }
}

#Preview {
    MyListView()
}
