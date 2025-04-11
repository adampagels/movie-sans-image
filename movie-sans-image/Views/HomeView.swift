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
                HStack {
                    Text(movie.title)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Button(movie.isInWatchlist ?? false ? "Added" : "add") {
                        if movie.isInWatchlist == false {
                            watchlistViewModel.addToWatchlist(movie: movie)
                        }
                        movieViewModel.toggleWatchlistStatus(movieID: movie.id)
                    }
                }
                .listRowSeparator(.hidden)
                .padding()
                .border(Color.purple, width: 4)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .listStyle(PlainListStyle())
        .task {
            await movieViewModel.loadPopularMovies()
            movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
        }
    }
}

#Preview() {
    HomeView(watchlistViewModel: WatchlistViewModel())
}
