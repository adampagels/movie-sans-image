//
//  MovieWatchlistStatusServiceTests.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-06.
//

@testable import movie_sans_image
import Testing

struct MovieWatchlistStatusServiceTests {
    @Test func toggleWatchlistFlag() {
        let service = MovieWatchlistStatusService()

        var testArray1 = [Movie](mockMovieArray)
        testArray1[0].isInWatchlist = false
        let updatedMovies1 = service.toggleWatchlistFlag(for: 1, movies: testArray1)
        #expect(updatedMovies1[0].isInWatchlist == true)

        var testArray2 = [Movie](mockMovieArray)
        testArray2[1].isInWatchlist = true
        let updatedMovies2 = service.toggleWatchlistFlag(for: 2, movies: testArray2)
        #expect(updatedMovies2[1].isInWatchlist == false)

        let testArray3 = [Movie](mockMovieArray)
        let updatedMovies3 = service.toggleWatchlistFlag(for: 999, movies: testArray3)
        #expect(updatedMovies3 == testArray3)
    }

    @Test func addWatchlistStatus() {
        let movieWatchlistStatusService = MovieWatchlistStatusService()

        let context = MockPersistenceController().viewContext
        let watchlistEntity = movie_sans_image.WatchlistEntity(context: context)
        watchlistEntity.idRaw = 1

        let watchlist = [watchlistEntity]

        let updatedMovies = movieWatchlistStatusService.addWatchListStatus(to: mockMovieArray, watchlist: watchlist)

        #expect(updatedMovies.count == 3)
        #expect(updatedMovies[0].isInWatchlist == true)
        #expect(updatedMovies[1].isInWatchlist == false)
    }
}
