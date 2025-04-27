//
//  PersistanceController.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-04-07.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static let modelName = "WatchlistContainer"

    static let model: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Unable to locate Core Data model")
        }
        return model
    }()

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(
            name: PersistenceController.modelName,
            managedObjectModel: PersistenceController.model
        )
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
