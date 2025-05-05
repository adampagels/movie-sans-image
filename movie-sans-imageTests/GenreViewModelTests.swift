//
//  GenreViewModelTests.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-21.
//

import CoreData
@testable import movie_sans_image
import Testing

struct MockPersistenceController {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init() {
        let container = NSPersistentContainer(
            name: PersistenceController.modelName,
            managedObjectModel: PersistenceController.model
        )

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        persistentContainer = container
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
    private var movieResults: [Movie]

    init(movieResults: [Movie] = []) {
        self.movieResults = movieResults
    }

    func discoverMovies(with _: String) async throws -> [Movie] {
        return movieResults
    }

    func fetchMovies(by _: MovieListCategory) async throws -> [Movie] {
        return movieResults
    }

    func searchMovies(by _: String) async throws -> [Movie] {
        return movieResults
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

        if case let .loaded(movies) = viewModel.loadingState {
            #expect(movies.count == 3)
            #expect(movies.first?.title == "A Working Man")
            #expect(movies.first?.genre_ids?.contains(28) == true)
        }
    }

//    func setUp() {}
//
//    func tearDown() {}

    @Test func shouldNotShowGenreListWhenThereAreNoSearchResults() async {
        let apiService = MockAPIService(movieResults: mockMovieArray)
        let movieWatchlistStatusService = MockMovieWatchlistStatusService()
        let viewModel = SearchViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )

        #expect(viewModel.shouldShowGenreList == true)

        await viewModel.searchMovies()

        #expect(viewModel.shouldShowGenreList == false)
    }

    @Test func shouldShowNoResultsMessageWhenThereAreNoSearchResults() async {
        let apiService = MockAPIService(movieResults: [])
        let movieWatchlistStatusService = MockMovieWatchlistStatusService()
        let viewModel = SearchViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )

        #expect(viewModel.shouldShowNoResultsMessage == false)

        await viewModel.searchMovies()

        #expect(viewModel.shouldShowNoResultsMessage == true)
    }
}

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
