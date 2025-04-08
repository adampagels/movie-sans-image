//
//  PersistanceController.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-07.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "WatchlistContainer")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
