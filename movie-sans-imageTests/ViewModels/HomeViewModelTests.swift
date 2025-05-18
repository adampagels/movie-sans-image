//
//  HomeViewModelTests.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-11.
//

@testable import movie_sans_image
import Testing

struct HomeViewModelTests {
    @Test func fetchMoviesByCategory() async throws {
        let apiService = MockAPIService(movieResults: mockMovieArray)
        let movieWatchlistStatusService = MovieWatchlistStatusService()
        let viewModel = HomeViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )

        viewModel.selectedCategory = .upcoming
        await viewModel.getMovies(showLoading: true)

        if case let .loaded(movies) = viewModel.loadingState {
            #expect(movies.count == 3)
            #expect(apiService.lastFetchCategory == .upcoming)
        } else {
            #expect(Bool(false), "Expected .loaded state but got \(viewModel.loadingState)")
        }
    }

    @Test func toggleWatchlistUpdatesLoadingStateWithToggledMovie() {
        let service = MovieWatchlistStatusService()
        let viewModel = HomeViewModel(
            apiService: MockAPIService(),
            movieWatchlistStatusService: service
        )

        var movie = mockMovieArray[0]
        movie.isInWatchlist = false

        viewModel.loadingState = .loaded([movie])

        viewModel.toggleWatchlistStatus(movieID: movie.id)

        if case let .loaded(updatedMovies) = viewModel.loadingState {
            #expect(updatedMovies[0].isInWatchlist == true, "isInWatchlist has been toggled to true")
        } else {
            #expect(Bool(false), "Movie list is not loaded")
        }
    }

    @Test func setWatchlistStatusToTrueIfMovieExistsInWatchlist() {
        let service = MovieWatchlistStatusService()
        let viewModel = HomeViewModel(
            apiService: MockAPIService(),
            movieWatchlistStatusService: service
        )

        let context = MockPersistenceController().viewContext
        let watchlistEntity = movie_sans_image.WatchlistEntity(context: context)
        watchlistEntity.idRaw = 1

        let watchlist = [watchlistEntity]

        let movie = mockMovieArray[0]

        viewModel.loadingState = .loaded([movie])

        viewModel.initializeWatchlistStatus(watchlist: watchlist)

        if case let .loaded(updatedMovies) = viewModel.loadingState {
            #expect(
                updatedMovies[0].isInWatchlist == true,
                "isInWatchlist to be true because it exists in the watchlist"
            )
        } else {
            #expect(Bool(false), "Movie list is not loaded")
        }
    }

    @Test func setWatchlistStatusToFalseIfMovieDoesNotExistInWatchlist() {
        let service = MovieWatchlistStatusService()
        let viewModel = HomeViewModel(
            apiService: MockAPIService(),
            movieWatchlistStatusService: service
        )

        let context = MockPersistenceController().viewContext
        let watchlistEntity = movie_sans_image.WatchlistEntity(context: context)
        watchlistEntity.idRaw = 2

        let watchlist = [watchlistEntity]

        let movie = mockMovieArray[0]

        viewModel.loadingState = .loaded([movie])

        viewModel.initializeWatchlistStatus(watchlist: watchlist)

        if case let .loaded(updatedMovies) = viewModel.loadingState {
            #expect(
                updatedMovies[0].isInWatchlist == false,
                "isInWatchlist to be false because it does not exist in the watchlist"
            )
        } else {
            #expect(Bool(false), "Movie list is not loaded")
        }
    }

    @Test func handleErrorProperly() async {
        let apiService = MockAPIService(movieResults: mockMovieArray, errorToThrow: APIError.serverError)
        let movieWatchlistStatusService = MovieWatchlistStatusService()
        let viewModel = HomeViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )

        await viewModel.getMovies(showLoading: true)

        if case let .failed(message) = viewModel.loadingState {
            #expect(message == APIError.serverError.localizedDescription)
        } else {
            #expect(Bool(false), "Expected .failed state but got \(viewModel.loadingState)")
        }
    }
}
