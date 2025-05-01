//
//  LoadingState.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-28.
//

enum LoadingState<Value: Equatable>: Equatable {
    case idle
    case loading
    case failed(String)
    case loaded(Value)
}
