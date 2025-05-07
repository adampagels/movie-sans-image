//
//  CoreDataServiceTests.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-06.
//

@testable import movie_sans_image
import Testing

struct CoreDataServiceTests {
    @Test func fetchWatchlistFromCoreData() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)

        do {
            service.addToWatchList(movie: mockMovieArray[0])

            let fetchedWatchlist = try service.fetchWatchlist()

            #expect(fetchedWatchlist.count == 1, "Watchlist should contain exactly one movie")
        } catch {
            print("error in test", error)
            #expect(Bool(false), "Failed to fetch watchlist: \(error)")
        }
    }

    @Test func addAndFetchMovieFromCoreData() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)

        service.addToWatchList(movie: mockMovieArray[0])

        do {
            let fetchedWatchlist = try service.fetchWatchlist()

            #expect(fetchedWatchlist.count == 1, "Watchlist should contain exactly one movie")
            #expect(fetchedWatchlist[0].id == mockMovieArray[0].id, "Movie ID should match the added movie")
        } catch {
            print("error in test", error)
            #expect(Bool(false), "Failed to fetch watchlist: \(error)")
        }
    }

    @Test func deleteMovieFromCoreData() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)

        service.addToWatchList(movie: mockMovieArray[0])

        do {
            let fetchedWatchlist = try service.fetchWatchlist()

            #expect(fetchedWatchlist.count == 1, "Watchlist should contain exactly one movie")
            #expect(fetchedWatchlist[0].id == mockMovieArray[0].id, "Movie ID should match the added movie")

            service.deleteWatchlistItem(movieID: mockMovieArray[0].id, entityList: fetchedWatchlist)

            let updatedWatchlist = try service.fetchWatchlist()
            #expect(updatedWatchlist.count == 0, "Watchlist should be empty after deletion")
        } catch {
            print("error in test", error)
            #expect(Bool(false), "Failed to fetch watchlist: \(error)")
        }
    }

    @Test func toggleWatchedStatusOfMovieInCoreData() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)

        service.addToWatchList(movie: mockMovieArray[0])

        do {
            let fetchedWatchlist = try service.fetchWatchlist()

            #expect(fetchedWatchlist.count == 1, "Watchlist should contain exactly one movie")
            #expect(fetchedWatchlist[0].id == mockMovieArray[0].id, "Movie ID should match the added movie")

            #expect(!fetchedWatchlist[0].isWatched, "isWatched should initalize as false")

            service.toggleWatched(entity: fetchedWatchlist[0])
            let refetchedWatchlist = try service.fetchWatchlist()

            #expect(refetchedWatchlist[0].isWatched, "isWatched should now be true")

        } catch {
            print("error in test", error)
            #expect(Bool(false), "Failed to fetch watchlist: \(error)")
        }
    }
}
