//
//  MockPersistanceController.swift
//  movie-sans-image
//
//  Created by Adam Pagels on 2025-05-06.
//

import CoreData
@testable import movie_sans_image

struct MockPersistenceController {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init() {
        let container = NSPersistentContainer(
            name: PersistenceController.modelName,
            managedObjectModel: PersistenceController.model
        )

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        persistentContainer = container
    }
}
