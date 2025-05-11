//
//  NeubrutalShadowStyle.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-11.
//

import SwiftUI

enum NeubrutalShadowStyle {
    case small, large

    var shadowOffset: CGPoint {
        switch self {
        case .small: return CGPoint(x: 2, y: 2)
        case .large: return CGPoint(x: 3, y: 5)
        }
    }
}
