//
//  Home.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-05.
//

import SwiftUI

struct HomeView: View {
    @State private var movieViewModel: MovieViewModel = .init(apiService: APIService())
    @Environment(WatchlistViewModel.self) private var watchlistViewModel

    var body: some View {
        List {
            ForEach(movieViewModel.latestMovies) { movie in
                HStack {
                    Text(movie.title)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Button("add") {
                        watchlistViewModel.addToWatchlist(movie: movie)
                    }
                }
                .listRowSeparator(.hidden)
                .padding()
                .border(Color.purple, width: 4)
            }
        }
        .listStyle(PlainListStyle())
        .task {
            await movieViewModel.loadPopularMovies()
        }
    }
}

#Preview() {
    HomeView()
}
