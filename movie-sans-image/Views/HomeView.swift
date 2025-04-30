//
//  Home.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-05.
//

import SwiftUI

struct HomeView: View {
    @State var movieViewModel: MovieViewModel
    var watchlistViewModel: WatchlistViewModel

    var body: some View {
        VStack {
            CategoryList(
                selectedCategory: movieViewModel.selectedCategory,
                onSelect: { (category: MovieListCategory) in
                    guard movieViewModel.selectedCategory != category else { return }
                    movieViewModel.loadingState = .loading
                    withAnimation {
                        movieViewModel.selectedCategory = category
                    }
                    Task {
                        await movieViewModel.getMovies()
                        movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                    }
                }
            )

            switch movieViewModel.loadingState {
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
                            withAnimation {
                                movieViewModel.toggleWatchlistStatus(movieID: movie.id)
                            }
                            watchlistViewModel.persistWatchlistChange(movie: movie)
                        },
                        onSelect: { (movie: Movie) in
                            movieViewModel.selectedMovie = movie
                        }
                    )
                }
                .buttonStyle(BorderlessButtonStyle())
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
                .sheet(item: $movieViewModel.selectedMovie) { movie in
                    DetailView(movie: movie)
                }

            case .failed:
                Text("Error")
                    .frame(maxHeight: .infinity, alignment: .center)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .task {
            movieViewModel.loadingState = .loading
            await movieViewModel.getMovies()
            movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
        }
        .toolbar {
            ThemeButton()
        }
    }
}

#Preview() {
    NavigationStack {
        HomeView(
            movieViewModel: MovieViewModel(
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
