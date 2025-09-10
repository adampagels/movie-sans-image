//
//  NoResultsView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-09-10.
//

import SwiftUI

struct NoResultsView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Looks like we're out of that.")
                .font(.title)
                .fontWeight(.bold)
            Text("Try searching for another movie and we'll see what we can do.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
        }
        .accessibilityIdentifier("NoResultsContainer")
        .padding()
        .padding(.vertical)
    }
}

#Preview() {
    NoResultsView()
}
