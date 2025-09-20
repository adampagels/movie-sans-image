//
//  EmptyStateView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-09-10.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
        }
        .accessibilityIdentifier("EmptyStateContainer")
        .padding()
        .padding(.vertical)
    }
}

#Preview() {
    EmptyStateView(
        title: "Looks like we're out of that.",
        subtitle: "Try searching for another movie and we'll see what we can do."
    )
}
