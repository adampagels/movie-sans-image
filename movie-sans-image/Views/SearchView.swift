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
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for movies...", text: $searchViewModel.searchText)
                    .submitLabel(.search)
                    .keyboardType(.numbersAndPunctuation)
                    .onSubmit {
                        Task {
                            await searchViewModel.searchMovies()
                            searchViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                        }
                    }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black, lineWidth: 2)
            )
            .padding()

            List {
                if searchViewModel.shouldShowGenreList {
                    Text("Search by genres")
                        .fontWeight(.bold)
                        .font(.title2)
                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)],
                        spacing: 22
                    ) {
                        ForEach(MovieGenre.allCases, id: \.rawValue) { genre in
                            NeubrutalContainerView(backgroundColour: genre.backgroundColor) {
                                Text(genre.rawValue)
                                    .padding()
                                    .padding(.vertical)
                                    .fixedSize()
                            }
                            .onTapGesture {
                                router.push(Route.genre(genre))
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }

                ForEach(searchViewModel.movies) { movie in
                    NeubrutalContainerView(backgroundColour: .gray) {
                        HStack {
                            Text(movie.title)
                                .padding()

                            Spacer()

                            Button {
                                withAnimation {
                                    searchViewModel.toggleWatchlistStatus(movieID: movie.id)
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
                            searchViewModel.selectedMovie = movie
                        }
                    }
                    .padding(.bottom)
                    .listRowSeparator(.hidden)
                }
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
    }
}
