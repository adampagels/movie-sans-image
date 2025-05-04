//
//  WatchlistEntity.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-04.
//

import CoreData
import Foundation

@objc(WatchlistEntity)
public class WatchlistEntity: NSManagedObject, Identifiable, MovieDetailsDisplayable {
    @NSManaged public var adult: Bool
    @NSManaged public var backdrop_path: String?
    @NSManaged public var idRaw: Int64
    @NSManaged public var original_language: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var title: String
    @NSManaged public var video: Bool
    @NSManaged public var vote_averageRaw: Double
    @NSManaged public var vote_countRaw: Int16
    @NSManaged public var isWatched: Bool

    public var id: Int { Int(idRaw) }
    public var vote_average: Double? { vote_averageRaw }
    public var vote_count: Int? { Int(vote_countRaw) }
}
