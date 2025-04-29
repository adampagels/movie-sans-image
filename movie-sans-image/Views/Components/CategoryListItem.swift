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
        NeubrutalContainerView(backgroundColor: isSelected ? .blue : .gray) {
            Text(category.rawValue)
                .padding()
                .onTapGesture {
                    onSelect(category)
                }
                .fixedSize()
        }
    }
}
