//
//  NeubrutalContainerView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-14.
//

import SwiftUI

struct NeubrutalContainerView<Content: View>: View {
    let backgroundColour: Color
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .offset(x: 3, y: 5)
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(backgroundColour)

            content

            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

#Preview {
    NeubrutalContainerView(backgroundColour: .red) {
        Text("inside container text")
            .padding()
    }
    .fixedSize()
}
