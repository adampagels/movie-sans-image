//
//  ThemeButton.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-22.
//

import SwiftUI

struct ThemeButton: ToolbarContent {
    @AppStorage("theme") var theme: Theme = .system
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NeubrutalContainerView(
                backgroundColor: theme.iconBackgroundColor,
                borderColor: Color.primaryColor,
                shadowStyle: .small
            ) {
                Image(systemName: theme.iconName)
                    .padding(7)
                    .foregroundStyle(theme.iconColor)
                    .fixedSize()
                    .imageScale(.small)
                    .symbolEffect(.bounce, options: .repeat(1), value: theme)
            }
            .padding(1.5)
            .onTapGesture {
                theme = theme == .dark ? .light : .dark
            }
        }
    }
}

#Preview("Light Mode") {
    NavigationStack {
        Text("Light Mode")
            .toolbar {
                ThemeButton()
            }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        Text("Dark Mode")
            .toolbar {
                ThemeButton()
            }
    }
    .preferredColorScheme(.dark)
}
