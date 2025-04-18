//
//  ContentView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

import SwiftUI

struct MainView: View {
    private let apiService = APIService()
    private let coreDataService = CoreDataService()
    @State var watchlistViewModel: WatchlistViewModel
    
    init() {
        _watchlistViewModel = State(wrappedValue: WatchlistViewModel(coreDataService: coreDataService))
    }

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView(
                    movieViewModel: MovieViewModel(apiService: apiService),
                    watchlistViewModel: watchlistViewModel
                )
            }

            Tab("Search", systemImage: "magnifyingglass") {
                SearchView(watchlistViewModel: watchlistViewModel)
            }

            Tab("Watchlist", systemImage: "list.bullet") {
                WatchlistView(watchlistViewModel: watchlistViewModel)
            }
        }
    }
}

#Preview {
    MainView()
}
