//
//  movie_sans_imageUITests.swift
//  movie-sans-imageUITests
//
//  Created by Adam Pagels on 2025-04-03.
//

import XCTest

final class movie_sans_imageUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {}

    func testMovieTitlePressOpensDetailView() {
        let movieItem = app.buttons["MovieListItem"].firstMatch
        movieItem.tap()

        let movieDetailSheet = app.otherElements["DetailViewSheet"]
        XCTAssertTrue(movieDetailSheet.exists)
    }

    func testDetailViewOpensDetailViewWithSelectedMovieTitle() {
        let movieItem = app.buttons["MovieListItem"].firstMatch
        movieItem.tap()

        let movieDetailSheet = app.otherElements["DetailViewSheet"]
        XCTAssertTrue(movieDetailSheet.exists)

        let movieTitleInDetailSheet = app.staticTexts["DetailViewMovieTitle"]

        XCTAssertEqual(movieItem.label, movieTitleInDetailSheet.label)
    }

    func testGenreSelectionNavigatesToViewWithMatchingGenreTitle() {
        let searchTab = app.tabBars["Tab Bar"].buttons["Search"]
        searchTab.tap()

        let genreItem = app.buttons["GenreListItem"].firstMatch
        let buttonLabel = genreItem.label
        genreItem.tap()

        let navTitle = app.navigationBars.element.staticTexts.firstMatch

        XCTAssertEqual(buttonLabel, navTitle.label)
    }

    func testMovieCanBeAddedAndRemovedFromWatchlist() {
        app.buttons["Add"].firstMatch.tap()

        let movieItemInHomeView = app.buttons["MovieListItem"].firstMatch
        let movieLabel = movieItemInHomeView.label

        app.tabBars["Tab Bar"].buttons["Watchlist"].tap()

        let movieItemInWatchlistView = app.buttons[movieLabel]
        movieItemInWatchlistView.swipeLeft()

        app.buttons["SwipeToDeleteButton"].tap()

        XCTAssertFalse(movieItemInWatchlistView.exists)
    }

    func testNestedTabsProperlyNavigate() {
        app.tabBars["Tab Bar"].buttons["Search"].tap()
        app.buttons["GenreListItem"].firstMatch.tap()

        let movieItemInGenreView = app.buttons["MovieListItem"].firstMatch
        let movieLabel = movieItemInGenreView.label

        app.buttons["Add"].firstMatch.tap()
        app.tabBars["Tab Bar"].buttons["Watchlist"].tap()

        let movieItemInWatchlistView = app.buttons[movieLabel]
        movieItemInWatchlistView.swipeLeft()

        XCTAssertTrue(movieItemInWatchlistView.exists)

        app.buttons["SwipeToDeleteButton"].tap()
        XCTAssertFalse(movieItemInWatchlistView.exists)

        app.tabBars["Tab Bar"].buttons["Search"].tap()

        XCTAssertTrue(movieItemInGenreView.exists)

        app.tabBars["Tab Bar"].buttons["Home"].tap()

        let movieItemInHomeView = app.buttons["MovieListItem"].firstMatch

        XCTAssertTrue(movieItemInHomeView.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
