//
//  MockCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Stéphane Rihet on 13/07/2022.
//

import Reciplease
import CoreData

final class MockCoreDataStack: CoreDataStack {
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        let persistentContainerName = "Reciplease"
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: persistentContainerName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}



