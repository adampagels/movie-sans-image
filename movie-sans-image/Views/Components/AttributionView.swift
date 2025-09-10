//
//  AttributionView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-09-10.
//

import SwiftUI

struct AttributionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("TMDBLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)

            Text("This product uses the TMDB API but is not endorsed or certified by TMDB.")
                .font(.custom("Futura", size: 10))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
}

#Preview {
    AttributionView()
}
