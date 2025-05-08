//
//  WatchlistViewModelTests.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-07.
//

@testable import movie_sans_image
import Testing

@MainActor
struct WatchlistViewModelTests {
    @Test func addMovieToWatchlist() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)
        let viewModel = WatchlistViewModel(coreDataService: service)

        viewModel.getWatchlist()
        #expect(viewModel.watchlist.isEmpty, "Watchlist should start empty")

        viewModel.addToWatchlist(movie: mockMovieArray[0])

        #expect(viewModel.watchlist.count == 1, "Watchlist should contain exactly one movie")
        #expect(viewModel.watchlist[0].id == mockMovieArray[0].id, "Movie ID should match the added movie")
    }

    @Test func removeMovieFromWatchlist() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)
        let viewModel = WatchlistViewModel(coreDataService: service)

        viewModel.addToWatchlist(movie: mockMovieArray[0])
        viewModel.removeFromWatchlist(movieID: mockMovieArray[0].id)

        #expect(viewModel.watchlist.isEmpty, "Watchlist should be empty after removal")
    }

    @Test func persistChangeOfAddingMovieToWatchlist() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)
        let viewModel = WatchlistViewModel(coreDataService: service)

        viewModel.persistWatchlistChange(movie: mockMovieArray[0])

        #expect(viewModel.watchlist.count == 1, "Watchlist should contain exactly one movie")
        #expect(viewModel.watchlist[0].id == mockMovieArray[0].id, "Movie ID should match the added movie")
    }

    @Test func persistChangeOfRemovingMovieFromWatchlist() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)
        let viewModel = WatchlistViewModel(coreDataService: service)

        var movie = mockMovieArray[0]
        movie.isInWatchlist = true

        viewModel.persistWatchlistChange(movie: movie)

        #expect(viewModel.watchlist.isEmpty, "Watchlist should be empty after removal")
    }

    @Test func checkMovieIsInitiallySetToUnWatched() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)
        let viewModel = WatchlistViewModel(coreDataService: service)

        viewModel.addToWatchlist(movie: mockMovieArray[0])

        #expect(!viewModel.watchlist[0].isWatched, "Movie should not be marked as watched initially")
    }

    @Test func canMarkMovieAsWatched() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)
        let viewModel = WatchlistViewModel(coreDataService: service)

        viewModel.addToWatchlist(movie: mockMovieArray[0])

        viewModel.markAsWatched(entity: viewModel.watchlist[0])

        #expect(viewModel.watchlist[0].isWatched, "Movie should be marked as watched")
    }

    @Test func canMarkMovieAsUnWatched() {
        let service = CoreDataService(container: MockPersistenceController().persistentContainer)
        let viewModel = WatchlistViewModel(coreDataService: service)

        viewModel.addToWatchlist(movie: mockMovieArray[0])

        viewModel.markAsWatched(entity: viewModel.watchlist[0])
        #expect(viewModel.watchlist[0].isWatched, "Movie should be marked as watched")

        viewModel.markAsWatched(entity: viewModel.watchlist[0])
        #expect(!viewModel.watchlist[0].isWatched, "Movie should be marked as unwatched")
    }
}
