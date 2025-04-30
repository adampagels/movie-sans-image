//
//  CategoryList.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-29.
//

import SwiftUI

struct CategoryList: View {
    let selectedCategory: MovieListCategory
    let onSelect: (MovieListCategory) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(MovieListCategory.allCases, id: \.rawValue) { category in
                    CategoryListItem(
                        category: category,
                        onSelect: onSelect,
                        isSelected: category == selectedCategory
                    )
                }
                .fixedSize()
            }
        }
        .padding()
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    CategoryList(selectedCategory: .nowPlaying, onSelect: { _ in })
}
