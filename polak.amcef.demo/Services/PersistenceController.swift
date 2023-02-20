//
//  Persistence.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 13/02/2023.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    public var viewContext: NSManagedObjectContext? {
        container?.viewContext
    }

    private lazy var container: NSPersistentContainer? = {
        let persistentContainer = NSPersistentContainer(name: "polak_amcef_demo")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if error == nil {
                persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
                persistentContainer.viewContext.undoManager = nil
                persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true
            }
        })
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return persistentContainer
    }()
}
