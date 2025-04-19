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
    @State var router = NavigationRouter()

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
                NavigationStack(path: $router.path) {
                    SearchView(watchlistViewModel: watchlistViewModel, router: router)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case let .genre(genre):
                                GenreView(genre: genre, genreViewModel: GenreViewModel(apiService: apiService))
                            }
                        }
                }
                .tint(.primary)
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
