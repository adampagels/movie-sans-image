//
//  MovieWatchlistStatusService.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-20.
//

protocol MovieWatchlistStatusServiceProtocol {
    func addWatchListStatus(to movies: [Movie], watchlist: [WatchlistEntity]) -> [Movie]
    func toggleWatchlistFlag(for movieID: Int, movies: [Movie]) -> [Movie]
}

class MovieWatchlistStatusService: MovieWatchlistStatusServiceProtocol {
    func addWatchListStatus(to movies: [Movie], watchlist: [WatchlistEntity]) -> [Movie] {
        return movies.map { mov in
            var movieToBeToggled = mov
            movieToBeToggled.isInWatchlist = watchlist.contains(where: { $0.id == movieToBeToggled.id })
            return movieToBeToggled
        }
    }

    func toggleWatchlistFlag(for movieID: Int, movies: [Movie]) -> [Movie] {
        guard let index = movies.firstIndex(where: { $0.id == movieID }) else { return movies }
        var updatedMovies = movies
        if updatedMovies[index].isInWatchlist == false {
            updatedMovies[index].isInWatchlist = true
        } else {
            updatedMovies[index].isInWatchlist = false
        }
        return updatedMovies
    }
}
