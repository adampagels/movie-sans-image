//
//  GenreListItem.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-19.
//

import SwiftUI

struct GenreListItem: View {
    var genre: MovieGenre
    var router: NavigationRouter
    var body: some View {
        NeubrutalContainerView(
            backgroundColor: genre.backgroundColor,
            borderColor: Color(red: 22 / 255, green: 22 / 255, blue: 22 / 255),
            shadowStyle: .large
        ) {
            Text(genre.rawValue)
                .padding()
                .padding(.vertical)
                .fixedSize()
                .foregroundStyle(.white)
                .font(.custom("Futura-Bold", size: 16))
        }
        .accessibility(addTraits: .isButton)
        .accessibilityIdentifier("GenreListItem")
        .onTapGesture {
            router.push(Route.genre(genre))
        }
    }
}

#Preview {
    GenreListItem(genre: .action, router: NavigationRouter())
        .frame(width: 160, height: 10)
}
