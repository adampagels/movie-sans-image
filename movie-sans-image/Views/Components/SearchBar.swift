//
//  SearchBar.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-19.
//

import SwiftUI

struct SearchBar: View {
    @FocusState private var hasFocus: Bool

    @Binding var searchText: String
    let onSubmit: () -> Void
    let onChange: (String) -> Void
    let emptySearchAttempts: Int

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.secondaryColor)
                TextField(
                    "",
                    text: $searchText,
                    prompt: Text("Search for movies")
                        .foregroundColor(.gray)
                )
                .accessibilityIdentifier("SearchBar")
                .accessibilityValue(hasFocus ? "focused" : "unfocused")
                .font(.custom("Futura", size: 16))
                .onChange(of: searchText) { _, newValue in
                    onChange(newValue)
                }
                .font(.callout)
                .focused($hasFocus)
                .tint(.secondaryColor)
                .submitLabel(.search)
                .keyboardType(.default)
                .onSubmit {
                    onSubmit()
                }

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.secondaryColor)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(Color.primaryColor))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 3).foregroundColor(hasFocus ? Color.tertiaryColor : Color.clear)
            )
            .foregroundColor(Color.secondaryColor)
            .sensoryFeedback(.error, trigger: emptySearchAttempts)
            .modifier(Shake(animatableData: CGFloat(emptySearchAttempts)))

            if hasFocus {
                Text("Cancel")
                    .accessibilityIdentifier("SearchBarCancelButton")
                    .font(.custom("Futura", size: 12))
                    .onTapGesture {
                        hasFocus = false
                    }
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    SearchBar(
        searchText: $searchText,
        onSubmit: {},
        onChange: { _ in },
        emptySearchAttempts: 1
    )
}
