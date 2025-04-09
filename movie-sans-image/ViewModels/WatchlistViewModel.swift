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

    init(coreDataService: CoreDataService = CoreDataService()) {
        self.coreDataService = coreDataService
        getWatchlist()
    }

    func addToWatchlist(movie: Movie) {
        coreDataService.addToWatchList(movie: movie)
        getWatchlist()
    }

    func removeFromWatchlist(indexSet: IndexSet) {
        coreDataService.deleteWatchlistItem(indexSet: indexSet, entityList: watchlist)
        getWatchlist()
    }

    func getWatchlist() {
        do {
            let fetchedWatchList = try coreDataService.fetchWatchlist()
            watchlist = fetchedWatchList
        } catch {
            print("this is erroring", error)
        }
    }
}
