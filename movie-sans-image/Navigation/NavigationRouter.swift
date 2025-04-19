//
//  NavigationRouter.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-18.
//

import SwiftUI

@Observable
class NavigationRouter {
    var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
