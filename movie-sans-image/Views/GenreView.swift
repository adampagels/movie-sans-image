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
        List {
            ForEach(genreViewModel.movies) { movie in
                NeubrutalContainerView(backgroundColour: .gray) {
                    HStack {
                        Text(movie.title)
                            .padding()

                        Spacer()

                        Button {
                            withAnimation {
                                genreViewModel.toggleWatchlistStatus(movieID: movie.id)
                            }
                            watchlistViewModel.persistWatchlistChange(movie: movie)
                        }
                        label: {
                            Image(systemName: movie.isInWatchlist ?? false ? "checkmark" : "plus")
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .contentTransition(.symbolEffect(.replace))
                    }
                    .onTapGesture {
                        genreViewModel.selectedMovie = movie
                    }
                }
                .padding(.bottom)
                .listRowSeparator(.hidden)
            }
        }
        .task {
            await genreViewModel.getMoviesByGenreID(genreID: genre.id)
            genreViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
        }
        .buttonStyle(BorderlessButtonStyle())
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
        .navigationTitle(genre.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .toolbarRole(.editor)
        .sheet(item: $genreViewModel.selectedMovie) { movie in
            DetailView(movie: movie)
        }
    }
}

#Preview {
    GenreView(
        genre: .action,
        watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService()),
        genreViewModel: GenreViewModel(
            apiService: APIService(),
            movieWatchlistStatusService: MovieWatchlistStatusService()
        )
    )
}
