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
    }

    func addToWatchlist(movie: Movie) {
        coreDataService.addToWatchList(movie: movie)
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
