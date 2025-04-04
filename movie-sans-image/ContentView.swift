//
//  ContentView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: MovieViewModel = .init(apiService: APIService())

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text(viewModel.networkError)
        }
        .task {
            await viewModel.loadPopularMovies()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
