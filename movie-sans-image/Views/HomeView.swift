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
            VStack {
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
                                    movieViewModel
                                        .initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                                }
                            }
                            .fixedSize()
                        }
                    }
                    .padding()
                    .listRowSeparator(.hidden)
                }
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
                .listRowSeparator(.hidden)

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
                await movieViewModel.getMovies()
                movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
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
