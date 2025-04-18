//
//  SearchView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-17.
//

import SwiftUI

struct SearchView: View {
    @State var watchlistViewModel: WatchlistViewModel
    @State private var searchViewModel: SearchViewModel = .init(apiService: APIService())

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
                ForEach(searchViewModel.searchedMovies) { movie in
                    NeubrutalContainerView(backgroundColour: .gray) {
                        HStack {
                            Text(movie.title)
                                .padding()

                            Spacer()

                            Button {
                                //                            withAnimation {
                                //                                movieViewModel.toggleWatchlistStatus(movieID: movie.id)
                                //                            }
                                //                            watchlistViewModel.persistWatchlistChange(movie: movie)
                                print("button pressed")
                            }
                            label: {
                                Image(systemName: movie.isInWatchlist ?? false ? "checkmark" : "plus")
                                    .foregroundStyle(.black)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .contentTransition(.symbolEffect(.replace))
                        }
                        //                    .onTapGesture {
                        //                        movieViewModel.selectedMovie = movie
                        //                    }
                    }
                    .padding(.bottom)
                    .listRowSeparator(.hidden)
                }
            }
            .padding(.top)
            .buttonStyle(BorderlessButtonStyle())
            .listStyle(PlainListStyle())
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    SearchView(watchlistViewModel: WatchlistViewModel(coreDataService: CoreDataService()))
}
