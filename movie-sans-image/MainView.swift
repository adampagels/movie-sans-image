//
//  ContentView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

import SwiftUI

struct MainView: View {
    @State var watchlistViewModel = WatchlistViewModel()
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView(watchlistViewModel: watchlistViewModel)
            }

            Tab("Home", systemImage: "list.bullet") {
                WatchlistView(watchlistViewModel: watchlistViewModel)
            }
        }
    }
}

#Preview {
    MainView()
}
