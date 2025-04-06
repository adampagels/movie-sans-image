//
//  Home.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-05.
//

import SwiftUI

struct HomeView: View {
    @State private var movieViewModel: MovieViewModel = .init(apiService: APIService())
    @State private var watchlistViewModel: WatchlistViewModel = .init(watchlistStorage: CoreDataWatchlistStorage())

    var body: some View {
        ScrollView {
            ForEach(movieViewModel.latestMovies) { movie in
                HStack {
                    Text(movie.title)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Button("add") {
                        watchlistViewModel.addToWatchlist(movie: movie)
                    }
                }
                .padding()
                .border(Color.purple, width: 4)
            }
        }
        .task {
            await movieViewModel.loadPopularMovies()
        }
        .padding()
    }
}

#Preview() {
    HomeView()
}
