//
//  Theme.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-16.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var iconName: String {
        switch self {
        case .system: return "circle.righthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .system: return .black
        case .light: return .yellow
        case .dark: return .white
        }
    }

    var iconBackgroundColor: Color {
        switch self {
        case .system: return .white
        case .light: return .blue
        case .dark: return .black
        }
    }
}
