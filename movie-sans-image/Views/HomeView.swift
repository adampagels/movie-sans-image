//
//  Home.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-05.
//

import SwiftUI

struct HomeView: View {
    @State var movieViewModel: MovieViewModel
    @State var watchlistViewModel: WatchlistViewModel
    @AppStorage("theme") var theme: Theme = .system

    var body: some View {
        NavigationStack {
            List {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(MovieListCategory.allCases, id: \.rawValue) { category in
                            NeubrutalContainerView(backgroundColour: movieViewModel
                                .selectedCategory == category ? .blue : .gray)
                            {
                                Text(category.rawValue)
                                    .padding()
                            }
                            .onTapGesture {
                                withAnimation {
                                    movieViewModel.selectCategory(category: category)
                                }
                                Task {
                                    await movieViewModel.getMovies()
                                    movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                                }
                            }
                            .fixedSize()
                        }
                    }
                    .padding(.vertical)
                    .listRowSeparator(.hidden)
                }
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
                .listRowSeparator(.hidden)

                ForEach(movieViewModel.movies) { movie in
                    NeubrutalContainerView(backgroundColour: .gray) {
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
            .scrollIndicators(.hidden)
            .task {
                await movieViewModel.getMovies()
                movieViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
            }
            .sheet(item: $movieViewModel.selectedMovie) { movie in
                DetailView(movie: movie)
            }
            .toolbar {
                NeubrutalContainerView(backgroundColour: theme == .dark ? .black : .blue) {
                    withAnimation {
                        Image(systemName: theme.iconName)
                            .padding(7)
                            .foregroundStyle(theme == .dark ? .white : .yellow)
                            .fixedSize()
                            .imageScale(.small)
                    }
                }
                .padding(.bottom)
                .onTapGesture {
                    theme = theme == .dark ? .light : .dark
                }
            }
        }
    }
}

#Preview() {
    HomeView(
        movieViewModel: MovieViewModel(apiService: APIService()),
        watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService())
    )
}
