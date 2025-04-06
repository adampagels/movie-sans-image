//
//  WatchlistViewModel.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-06.
//

import SwiftUI

@Observable
class WatchlistViewModel {
    private let watchlistStorage: CoreDataWatchlistStorage

    init(watchlistStorage: CoreDataWatchlistStorage) {
        self.watchlistStorage = watchlistStorage
    }

    func addToWatchlist(movie: Movie) {
        watchlistStorage.addToWatchList(movie: movie)
    }
}
