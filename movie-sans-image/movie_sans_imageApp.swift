//
//  movie_sans_imageApp.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

import SwiftUI

@main
struct movie_sans_imageApp: App {
    @State var watchlistViewModel = WatchlistViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(watchlistViewModel)
        }
    }
}
