//
//  WatchlistViewModel.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-06.
//

import SwiftUI

@Observable
class WatchlistViewModel {
    private let coreDataService: CoreDataService
    var watchlist: [WatchlistEntity] = []

    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        getWatchlist()
    }

    func addToWatchlist(movie: Movie) {
        coreDataService.addToWatchList(movie: movie)
        getWatchlist()
    }

    func removeFromWatchlist(movieID: Int) {
        coreDataService.deleteWatchlistItem(movieID: movieID, entityList: watchlist)
        getWatchlist()
    }

    func persistWatchlistChange(movie: Movie) {
        if movie.isInWatchlist == true {
            removeFromWatchlist(movieID: movie.id)
        } else {
            addToWatchlist(movie: movie)
        }
    }

    func getWatchlist() {
        do {
            let fetchedWatchList = try coreDataService.fetchWatchlist()
            watchlist = fetchedWatchList
        } catch {
            print("this is erroring", error)
        }
    }

    func markAsWatched(entity: WatchlistEntity) {
        coreDataService.toggleWatched(entity: entity)
        getWatchlist()
    }
}
