//
//  ContentView.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-03.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }

            Tab("Home", systemImage: "list.bullet") {
                MyListView()
            }
        }
    }
}

#Preview {
    MainView()
}
