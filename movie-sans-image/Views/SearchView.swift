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
                    .accessibilityIdentifier("SearchBar")
                    .accessibilityValue(hasFocus ? "focused" : "unfocused")
                    .font(.custom("Futura", size: 16))
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
                        guard !searchViewModel.searchText.isEmpty else {
                            return withAnimation(.default) {
                                searchViewModel.attempts += 1
                            }
                        }
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
                .sensoryFeedback(.error, trigger: searchViewModel.attempts)
                .modifier(Shake(animatableData: CGFloat(searchViewModel.attempts)))

                if hasFocus {
                    Text("Cancel")
                        .accessibilityIdentifier("SearchBarCancelButton")
                        .font(.custom("Futura", size: 12))
                        .onTapGesture {
                            hasFocus = false
                        }
                }
            }
            .padding()

            if searchViewModel.shouldShowGenreList {
                List {
                    Text("Discover by genre")
                        .font(.custom("Futura-Bold", size: 17))
                        .listRowBackground(Color.backgroundColor)
                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)],
                        spacing: 22
                    ) {
                        ForEach(MovieGenre.allCases, id: \.rawValue) { genre in
                            NeubrutalContainerView(
                                backgroundColor: genre.backgroundColor,
                                borderColor: Color(red: 22 / 255, green: 22 / 255, blue: 22 / 255),
                                shadowStyle: .large
                            ) {
                                Text(genre.rawValue)
                                    .padding()
                                    .padding(.vertical)
                                    .fixedSize()
                                    .foregroundStyle(.white)
                                    .font(.custom("Futura-Bold", size: 16))
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
                    .accessibilityIdentifier("NoResultsContainer")
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

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size _: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
