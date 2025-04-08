//
//  CoreDataService.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-07.
//

import CoreData

class CoreDataService: CoreDataServiceProtocol {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = PersistenceController.shared.persistentContainer) {
        self.container = container
    }

    func saveData() {
        do {
            try container.viewContext.save()
        } catch {
            print("error saving to watchlist: \(error)")
        }
    }

    func addToWatchList(movie: Movie) {
        let newMovie = WatchlistEntity(context: container.viewContext)

        newMovie.adult = movie.adult
        newMovie.backdrop_path = movie.backdrop_path
        newMovie.id = Int64(movie.id)
        newMovie.original_title = movie.original_title
        newMovie.overview = movie.overview
        newMovie.popularity = movie.popularity
        newMovie.poster_path = movie.poster_path
        newMovie.release_date = movie.release_date
        newMovie.title = movie.title
        newMovie.video = movie.video
        newMovie.vote_average = movie.vote_average ?? 0.0
        newMovie.vote_count = Int16(movie.vote_count ?? 0)
//        newMovie.genre_ids = movie.genre_ids

        saveData()
    }

    func fetchWatchlist() throws -> [WatchlistEntity] {
        let request = NSFetchRequest<WatchlistEntity>(entityName: "WatchlistEntity")

        do {
            print("fetching")
            let watchlist = try container.viewContext.fetch(request)
            return watchlist
        } catch {
            print("error fetching watchlist: \(error)")
            throw error
        }
    }
}
