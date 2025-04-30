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

            if searchViewModel.shouldShowGenreList {
                List {
                    Text("Search by genres")
                        .fontWeight(.bold)
                        .font(.title2)
                        .listRowBackground(Color.backgroundColor)
                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)],
                        spacing: 22
                    ) {
                        ForEach(MovieGenre.allCases, id: \.rawValue) { genre in
                            NeubrutalContainerView(
                                backgroundColor: genre.backgroundColor,
                                borderColor: .black
                            ) {
                                Text(genre.rawValue)
                                    .padding()
                                    .padding(.vertical)
                                    .fixedSize()
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier("GenreListItem")
                            .onTapGesture {
                                router.push(Route.genre(genre))
                            }
                        }
                    }
                    .listRowBackground(Color.backgroundColor)
                    .listRowSeparator(.hidden)
                }
                .buttonStyle(BorderlessButtonStyle())
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
            }

            switch searchViewModel.loadingState {
            case .idle:
                EmptyView()

            case .loading:
                ProgressView()
                    .frame(maxHeight: .infinity, alignment: .center)

            case let .loaded(movies):
                if !searchViewModel.shouldShowGenreList {
                    List {
                        MovieList(
                            movies: movies,
                            toggleWatchlist: { (movie: Movie) in
                                withAnimation {
                                    searchViewModel.toggleWatchlistStatus(movieID: movie.id)
                                }
                                watchlistViewModel.persistWatchlistChange(movie: movie)
                            },
                            onSelect: { (movie: Movie) in
                                searchViewModel.selectedMovie = movie
                            }
                        )
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

            case .failed:
                Text("Error")
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
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
        .background(Color.backgroundColor)
    }
}
