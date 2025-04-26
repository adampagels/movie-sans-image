//
//  GenreViewModelTests.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-21.
//

import CoreData
@testable import movie_sans_image
import Testing

class TestCoreDataStack {
    static let shared = TestCoreDataStack()

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "WatchlistContainer")

        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory Core Data stack: \(error)")
            }
        }
    }
}

var mockMovieArray: [Movie] = [Movie(
    adult: false,
    backdrop_path: "/fTrQsdMS2MUw00RnzH0r3JWHhts.jpg",
    genre_ids: [28, 80, 53],
    id: 1,
    original_language: "en",
    original_title: "A Working Man",
    overview: "Levon Cade left behind a decorated military career in the black ops to live a simple life working construction. But when his boss's daughter, who is like family to him, is taken by human traffickers, his search to bring her home uncovers a world of corruption far greater than he ever could have imagined.",
    popularity: 1110.4627,
    poster_path: "/xUkUZ8eOnrOnnJAfusZUqKYZiDu.jpg",
    release_date: "2025-03-26",
    title: "A Working Man",
    video: false,
    vote_average: 6.257,
    vote_count: 352
),
Movie(
    adult: false,
    backdrop_path: "/op3qmNhvwEvyT7UFyPbIfQmKriB.jpg",
    genre_ids: [14, 12, 28],
    id: 2,
    original_language: "en",
    original_title: "In the Lost Lands",
    overview: "A queen sends the powerful and feared sorceress Gray Alys to the ghostly wilderness of the Lost Lands in search of a magical power, where she and her guide, the drifter Boyce, must outwit and outfight both man and demon.",
    popularity: 632.0434,
    poster_path: "/iHf6bXPghWB6gT8kFkL1zo00x6X.jpg",
    release_date: "2025-02-27",
    title: "In the Lost Lands",
    video: false,
    vote_average: 6.297,
    vote_count: 244
),
Movie(
    adult: false,
    backdrop_path: "/jhL4eTpccoZSVehhcR8DKLSBHZy.jpg",
    genre_ids: [28, 53, 878],
    id: 3,
    original_language: "en",
    original_title: "Captain America: Brave New World",
    overview: "After meeting with newly elected U.S. President Thaddeus Ross, Sam finds himself in the middle of an international incident. He must discover the reason behind a nefarious global plot before the true mastermind has the entire world seeing red.",
    popularity: 476.0999,
    poster_path: "/pzIddUEMWhWzfvLI3TwxUG2wGoi.jpg",
    release_date: "2025-02-12",
    title: "Captain America: Brave New World",
    video: false,
    vote_average: 6.1,
    vote_count: 1553
)]

class MockAPIService: APIServiceProtocol {
    func discoverMovies(with genreID: String) async throws -> [Movie] {
        if genreID == "28" { // Action genre
            return mockMovieArray
        }
        return []
    }

    func fetchMovies(by _: MovieListCategory) async throws -> [Movie] {
        return []
    }

    func searchMovies(by _: String) async throws -> [Movie] {
        return mockMovieArray
    }
}

class MockMovieWatchlistStatusService: MovieWatchlistStatusServiceProtocol {
    func addWatchListStatus(to movies: [Movie], watchlist _: [movie_sans_image.WatchlistEntity]) -> [Movie] {
        return movies
    }

    func toggleWatchlistFlag(for _: Int, movies: [Movie]) -> [Movie] {
        return movies
    }
}

struct GenreViewModelTests {
    @Test func fetchMoviesbyGenre() async throws {
        let apiService = MockAPIService()
        let movieWatchlistStatusService = MockMovieWatchlistStatusService()
        let viewModel = GenreViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )

        await viewModel.getMoviesByGenreID(genreID: "28")

        #expect(viewModel.movies.count == 3)
        #expect(viewModel.movies.first?.title == "A Working Man")
        #expect(viewModel.movies.first?.genre_ids?.contains(28) == true)
    }

//    func setUp() {}
//
//    func tearDown() {}

    @Test func shouldShowGenreListWhenThereAreNoSearchResults() {
        let apiService = MockAPIService()
        let movieWatchlistStatusService = MockMovieWatchlistStatusService()
        let viewModel = SearchViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )

        viewModel.movies = []

        #expect(viewModel.shouldShowGenreList == true)

        viewModel.movies = mockMovieArray

        #expect(viewModel.shouldShowGenreList == false)
    }
}
