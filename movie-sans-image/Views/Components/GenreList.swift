//
//  GenreList.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-19.
//

import SwiftUI

struct GenreList: View {
    var router: NavigationRouter
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)],
            spacing: 22
        ) {
            ForEach(MovieGenre.allCases, id: \.rawValue) { genre in
                GenreListItem(genre: genre, router: router)
            }
        }
        .listRowBackground(Color.backgroundColor)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    List {
        GenreList(router: NavigationRouter())
    }
    .listRowBackground(Color.backgroundColor)
    .listRowSeparator(.hidden)
}
