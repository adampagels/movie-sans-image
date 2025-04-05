//
//  Home.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-05.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: MovieViewModel = .init(apiService: APIService())

    var body: some View {
        ScrollView {
            ForEach(viewModel.latestMovies) { movie in
                HStack {
                    Text(movie.title)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding()
                .border(Color.purple, width: 4)
            }
        }
        .task {
            await viewModel.loadPopularMovies()
        }
        .padding()
    }
}

#Preview() {
    HomeView()
}
