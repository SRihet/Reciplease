//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 27/05/2022.
//

import Foundation
import CoreData

open class CoreDataStack {
    
    // MARK: - Initializer
    public init() {
    }
    
    // MARK: - Core Data stack
    public static let persistentContainerName = "Reciplease"
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.persistentContainerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    public func saveContext() -> Bool {
        var isSaved = false
        guard mainContext.hasChanges else { return isSaved }
        do {
            try mainContext.save()
            isSaved = true
        } catch let error as NSError {
            isSaved = false
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return isSaved
    }
}
