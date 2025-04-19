//
//  GenreView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-18.
//

import SwiftUI

struct GenreView: View {
    let genre: MovieGenre
    var genreViewModel: GenreViewModel
    var body: some View {
        List {
            ForEach(genreViewModel.movies) { movie in
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
        .task {
            await genreViewModel.getMoviesByGenreID(genreID: genre.id)
        }
        .buttonStyle(BorderlessButtonStyle())
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
        .navigationTitle(genre.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .toolbarRole(.editor)
    }
}

#Preview {
    GenreView(genre: .action, genreViewModel: GenreViewModel(apiService: APIService()))
}
