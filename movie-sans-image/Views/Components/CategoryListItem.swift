//
//  CategoryListItem.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-29.
//

import SwiftUI

struct CategoryListItem: View {
    let category: MovieListCategory
    let onSelect: (MovieListCategory) -> Void
    let isSelected: Bool

    var body: some View {
        NeubrutalContainerView(backgroundColor: isSelected ? Color(red: 207 / 255, green: 254 / 255, blue: 26 / 255) :
            Color(
                red: 211 / 255.0,
                green: 211 / 255.0,
                blue: 211 / 255.0
            ), borderColor: Color(red: 22 / 255, green: 22 / 255, blue: 22 / 255)) {
                Text(category.rawValue)
                    .font(.footnote)
                    .foregroundStyle(Color(red: 22 / 255, green: 22 / 255, blue: 22 / 255))
                    .padding()
                    .fixedSize()
            }
            .onTapGesture {
                onSelect(category)
            }
    }
}

#Preview {
    HStack {
        CategoryListItem(category: .nowPlaying, onSelect: { _ in }, isSelected: true)
            .fixedSize()
        CategoryListItem(category: .popular, onSelect: { _ in }, isSelected: false)
            .fixedSize()
    }
}
