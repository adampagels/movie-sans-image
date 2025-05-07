//
//  SearchViewModelTests.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-06.
//

@testable import movie_sans_image
import Testing

struct ViewModelTests {
    @Test func shouldNotShowGenreListWhenThereAreNoSearchResults() async {
        let apiService = MockAPIService(movieResults: mockMovieArray)
        let movieWatchlistStatusService = MovieWatchlistStatusService()
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
        let movieWatchlistStatusService = MovieWatchlistStatusService()
        let viewModel = SearchViewModel(
            apiService: apiService,
            movieWatchlistStatusService: movieWatchlistStatusService
        )

        #expect(viewModel.shouldShowNoResultsMessage == false)

        await viewModel.searchMovies()

        #expect(viewModel.shouldShowNoResultsMessage == true)
    }

    @Test func toggleWatchlistUpdatesLoadingStateWithToggledMovie() {
        let service = MovieWatchlistStatusService()
        let viewModel = SearchViewModel(
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
        let viewModel = SearchViewModel(
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
        let viewModel = SearchViewModel(
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
}
