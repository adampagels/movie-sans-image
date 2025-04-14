//
//  Home.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-05.
//

import SwiftUI

struct HomeView: View {
    @State private var movieViewModel: MovieViewModel = .init(apiService: APIService())
    @State var watchlistViewModel: WatchlistViewModel

    var body: some View {
        List {
            ForEach(movieViewModel.latestMovies) { movie in
                NeubrutalContainerView {
                    HStack {
                        Text(movie.title)
                            .padding()

                        Spacer()

                        Button {
                            withAnimation {
                                movieViewModel.toggleWatchlistStatus(movieID: movie.id)
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
                        movieViewModel.selectedMovie = movie
                    }
                }
                .padding(.bottom)
                .listRowSeparator(.hidden)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .listStyle(PlainListStyle())
        .task {
            await movieViewModel.loadPopularMovies()
            movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
        }
        .sheet(item: $movieViewModel.selectedMovie) { movie in
            DetailView(movie: movie)
        }
    }
}

#Preview() {
    HomeView(watchlistViewModel: WatchlistViewModel())
}
