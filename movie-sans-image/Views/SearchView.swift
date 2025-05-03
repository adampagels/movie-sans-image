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
    @FocusState private var hasFocus: Bool

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.secondaryColor)
                    TextField(
                        "",
                        text: $searchViewModel.searchText,
                        prompt: Text("Search for movies")
                            .foregroundColor(.gray)
                    )
                    .onChange(of: searchViewModel.searchText) { _, newValue in
                        if newValue == "" {
                            searchViewModel.shouldShowGenreList = true
                            searchViewModel.shouldShowNoResultsMessage = false
                        }
                    }
                    .font(.callout)
                    .focused($hasFocus)
                    .tint(.secondaryColor)
                    .submitLabel(.search)
                    .keyboardType(.default)
                    .onSubmit {
                        guard !searchViewModel.searchText.isEmpty else { return }
                        Task {
                            await searchViewModel.searchMovies()
                            searchViewModel.initializeWatchlistStatus(watchlist: watchlistViewModel.watchlist)
                        }
                    }

                    if !searchViewModel.searchText.isEmpty {
                        Button(action: { searchViewModel.searchText = "" }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.secondaryColor)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primaryColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 3).foregroundColor(hasFocus ? Color.tertiaryColor : Color.clear)
                )
                .foregroundColor(Color.secondaryColor)
                .onAppear { hasFocus = searchViewModel.hasFocus }
                .onChange(of: hasFocus) { _, newValue in
                    searchViewModel.hasFocus = newValue
                }
                .onChange(of: searchViewModel.hasFocus) { _, newValue in
                    hasFocus = newValue
                }

                if hasFocus {
                    Text("Cancel")
                        .font(.footnote)
                        .onTapGesture {
                            hasFocus = false
                        }
                }
            }
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
                if searchViewModel.shouldShowNoResultsMessage {
                    VStack(alignment: .center) {
                        Text("Looks like we're out of that.")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Try searching for another movie and we'll see what we can do.")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    .padding(.vertical)
                }

                if !searchViewModel.shouldShowGenreList {
                    List {
                        MovieList(
                            movies: movies,
                            toggleWatchlist: { (movie: Movie) in
                                searchViewModel.toggleWatchlistStatus(movieID: movie.id)
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
