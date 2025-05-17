//
//  Home.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-05.
//

import SwiftUI

struct HomeView: View {
    @State var homeViewModel: HomeViewModel
    var watchlistViewModel: WatchlistViewModel

    var body: some View {
        VStack {
            CategoryList(
                selectedCategory: homeViewModel.selectedCategory,
                onSelect: { (category: MovieListCategory) in
                    guard homeViewModel.selectedCategory != category,
                          homeViewModel.loadingState != .loading else { return }
                    Task {
                        withAnimation {
                            homeViewModel.selectedCategory = category
                        }

                        await homeViewModel.getMovies(showLoading: true)
                        homeViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                    }
                }
            )

            switch homeViewModel.loadingState {
            case .idle:
                EmptyView()

            case .loading:
                ProgressView()
                    .frame(maxHeight: .infinity, alignment: .center)

            case let .loaded(movies):
                List {
                    MovieList(
                        movies: movies,
                        toggleWatchlist: { (movie: Movie) in
                            homeViewModel.toggleWatchlistStatus(movieID: movie.id)
                            watchlistViewModel.persistWatchlistChange(movie: movie)
                        },
                        onSelect: { (movie: Movie) in
                            homeViewModel.selectedMovie = movie
                        }
                    )
                }
                .refreshable(action: {
                    await homeViewModel.getMovies(showLoading: false)
                    homeViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                })
                .buttonStyle(BorderlessButtonStyle())
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
                .sheet(item: $homeViewModel.selectedMovie) { movie in
                    DetailView(movie: movie)
                }

            case .failed:
                Text("Error")
                    .frame(maxHeight: .infinity, alignment: .center)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .task {
            await homeViewModel.getMovies(showLoading: true)
            homeViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
        }
        .toolbar {
            ThemeButton()
        }
    }
}

#Preview() {
    NavigationStack {
        HomeView(
            homeViewModel: HomeViewModel(
                apiService: APIService(),
                movieWatchlistStatusService: MovieWatchlistStatusService()
            ),
            watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService())
        )
        .background(Color.backgroundColor)
    }
    .toolbar {
        ThemeButton()
    }
}
