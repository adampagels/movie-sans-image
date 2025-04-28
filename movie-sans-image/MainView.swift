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
    private let movieWatchlistStatusService = MovieWatchlistStatusService()
    var watchlistViewModel: WatchlistViewModel
    var searchViewModel: SearchViewModel
    var movieViewModel: MovieViewModel
    @State private var homeRouter = NavigationRouter()
    @State private var searchRouter = NavigationRouter()
    @State private var watchlistRouter = NavigationRouter()

    init() {
        watchlistViewModel = WatchlistViewModel(coreDataService: coreDataService)
        movieViewModel = MovieViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )
        searchViewModel = SearchViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack(path: $homeRouter.path) {
                    HomeView(movieViewModel: movieViewModel, watchlistViewModel: watchlistViewModel)
                }
            }

            Tab("Search", systemImage: "magnifyingglass") {
                NavigationStack(path: $searchRouter.path) {
                    SearchView(
                        watchlistViewModel: watchlistViewModel,
                        searchViewModel: searchViewModel, router: searchRouter
                    )
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case let .genre(genre):
                            GenreView(
                                genre: genre,
                                watchlistViewModel: watchlistViewModel,
                                genreViewModel: GenreViewModel(
                                    apiService: apiService,
                                    movieWatchlistStatusService: movieWatchlistStatusService
                                )
                            )
                        }
                    }
                }
                .tint(.primaryColor)
            }

            Tab("Watchlist", systemImage: "list.bullet") {
                NavigationStack(path: $watchlistRouter.path) {
                    WatchlistView(watchlistViewModel: watchlistViewModel)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
