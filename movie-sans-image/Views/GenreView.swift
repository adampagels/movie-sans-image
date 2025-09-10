//
//  GenreView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-18.
//

import SwiftUI

struct GenreView: View {
    let genre: MovieGenre
    var watchlistViewModel: WatchlistViewModel
    @State var genreViewModel: GenreViewModel
    var body: some View {
        VStack {
            switch genreViewModel.loadingState {
            case .idle:
                EmptyView()

            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            case let .loaded(movies):
                List {
                    MovieList(
                        movies: movies,
                        toggleWatchlist: { (movie: Movie) in
                            genreViewModel.toggleWatchlistStatus(movieID: movie.id)
                            watchlistViewModel.persistWatchlistChange(movie: movie)
                        },
                        onSelect: { (movie: Movie) in
                            genreViewModel.selectedMovie = movie
                        }
                    )
                }
                .refreshable(action: {
                    await genreViewModel.getMoviesByGenreID(genreID: genre.id, showLoading: false)
                    genreViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                })
                .buttonStyle(BorderlessButtonStyle())
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
                .sheet(item: $genreViewModel.selectedMovie) { movie in
                    DetailView(movie: movie)
                }

            case let .failed(error):
                Text(error)
                    .multilineTextAlignment(.center)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding()
                    .foregroundStyle(.red)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task {
            await genreViewModel.getMoviesByGenreID(genreID: genre.id, showLoading: true)
            genreViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
        }
        .toolbar {
            ThemeButton()
        }
        .navigationTitle(genre.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .toolbarRole(.editor)
    }
}

#Preview {
    NavigationStack {
        GenreView(
            genre: .action,
            watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService()),
            genreViewModel: GenreViewModel(
                apiService: APIService(),
                movieWatchlistStatusService: MovieWatchlistStatusService()
            )
        )
        .background(Color.backgroundColor)
    }
}
