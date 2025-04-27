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
    @AppStorage("theme") var theme: Theme = .system

    var body: some View {
        NavigationStack {
            List {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(MovieListCategory.allCases, id: \.rawValue) { category in
                            NeubrutalContainerView(backgroundColor: movieViewModel
                                .selectedCategory == category ? .blue : .gray)
                            {
                                Text(category.rawValue)
                                    .padding()
                            }
                            .onTapGesture {
                                withAnimation {
                                    movieViewModel.selectedCategory = category
                                }
                                Task {
                                    await movieViewModel.getMovies()
                                    movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                                }
                            }
                            .fixedSize()
                        }
                    }
                    .padding(.vertical)
                    .listRowSeparator(.hidden)
                }
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
                .listRowSeparator(.hidden)

                MovieList(
                    movies: movieViewModel.movies,
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
            .task {
                await movieViewModel.getMovies()
                movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
            }
            .sheet(item: $movieViewModel.selectedMovie) { movie in
                DetailView(movie: movie)
            }
            .toolbar {
                ThemeButton()
            }
        }
    }
}

#Preview() {
    HomeView(
        movieViewModel: MovieViewModel(
            apiService: APIService(),
            movieWatchlistStatusService: MovieWatchlistStatusService()
        ),
        watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService())
    )
}
