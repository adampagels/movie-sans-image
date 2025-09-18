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
            Button {
                theme = theme == .dark ? .light : .dark
            } label: {
                Image(systemName: theme.iconName)
                    .foregroundStyle(theme.iconColor)
                    .imageScale(.medium)
                    .symbolEffect(.bounce, options: .repeat(1), value: theme)
                    .fixedSize()
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
