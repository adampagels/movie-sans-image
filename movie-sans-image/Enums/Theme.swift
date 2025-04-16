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
        case .system: return "moon.circle.fill"
        case .light: return "sun.max.fill"
        case .dark: return "moon.stars.fill"
        }
    }

    var displayName: String {
        switch self {
        case .system: return "Automatic"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}
