//
//  CoreDataServiceProtocol.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-07.
//

protocol CoreDataServiceProtocol {
    func addToWatchList(movie: Movie)
    func saveData()
    func fetchWatchlist() throws -> [WatchlistEntity]
}
