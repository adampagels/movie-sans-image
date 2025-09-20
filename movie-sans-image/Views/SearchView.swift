//
//  SearchView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-17.
//

import SwiftUI

struct SearchView: View {
    var watchlistViewModel: WatchlistViewModel
    @State var searchViewModel: SearchViewModel
    @State var router: NavigationRouter

    var body: some View {
        VStack {
            SearchBar(
                searchText: $searchViewModel.searchText,
                onSubmit: {
                    guard !searchViewModel.searchText.isEmpty else {
                        return withAnimation(.default) {
                            searchViewModel.emptySearchAttempts += 1
                        }
                    }
                    Task {
                        await searchViewModel.searchMovies()
                        searchViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                    }
                },
                onChange: { (newValue: String) in
                    if newValue == "" {
                        searchViewModel.shouldShowGenreList = true
                        searchViewModel.shouldShowNoResultsMessage = false
                    }
                },
                emptySearchAttempts: searchViewModel.emptySearchAttempts
            )

            if searchViewModel.shouldShowGenreList {
                List {
                    Text("Discover by genre")
                        .font(.custom("Futura-Bold", size: 17))
                        .listRowBackground(Color.backgroundColor)

                    GenreList(router: router)
                }
                .buttonStyle(BorderlessButtonStyle())
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
            }

            switch searchViewModel.loadingState {
            case .idle:
                EmptyView()

            case .loading:
                ProgressView()
                    .frame(maxHeight: .infinity, alignment: .center)

            case let .loaded(movies):
                if searchViewModel.shouldShowNoResultsMessage {
                    EmptyStateView(
                        title: "Looks like we're out of that.",
                        subtitle: "Try searching for another movie and we'll see what we can do."
                    )
                }

                if !searchViewModel.shouldShowGenreList {
                    List {
                        MovieList(
                            movies: movies,
                            toggleWatchlist: { (movie: Movie) in
                                searchViewModel.toggleWatchlistStatus(movieID: movie.id)
                                watchlistViewModel.persistWatchlistChange(movie: movie)
                            },
                            onSelect: { (movie: Movie) in
                                searchViewModel.selectedMovie = movie
                            }
                        )
                        .task {
                            searchViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .listStyle(PlainListStyle())
                    .scrollIndicators(.hidden)
                    .sheet(item: $searchViewModel.selectedMovie) { movie in
                        DetailView(movie: movie)
                    }
                }

            case let .failed(error):
                Text(error)
                    .multilineTextAlignment(.center)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding()
                    .foregroundStyle(.red)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ThemeButton()
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(
            watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService()),
            searchViewModel: SearchViewModel(
                apiService: APIService(),
                movieWatchlistStatusService: MovieWatchlistStatusService()
            ),
            router: NavigationRouter()
        )
        .background(Color.backgroundColor)
    }
}
