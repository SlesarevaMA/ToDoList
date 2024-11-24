//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//

import CoreData

protocol CoreDataManager: AnyObject {
    func save(_ saveClosure: @escaping (NSManagedObjectContext) -> Void) throws
    func read<T: NSFetchRequestResult, O>(
        fetchReuqest: NSFetchRequest<T>,
        mapClosure: @escaping (T) -> O
    ) throws -> [O]
    func delete<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) throws
}

final class CoreDataManagerImpl: CoreDataManager {
    private let persistentContainer: NSPersistentContainer
    private let objectContext: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "DBToDoList")

        container.loadPersistentStores { description, error in
            if let error {
                print("Load persistant store error: \(error.localizedDescription)")
            }
            
            print("Database location: \(description.url?.absoluteString ?? "")")
        }

        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        persistentContainer = container
        objectContext = context
    }
    
    func save(_ saveClosure: @escaping (NSManagedObjectContext) -> Void) throws {
        try objectContext.performAndWait {
            saveClosure(self.objectContext)
            try self.save()
        }
    }
    
    func read<T: NSFetchRequestResult, O>(
        fetchReuqest: NSFetchRequest<T>,
        mapClosure: @escaping (T) -> O
    ) throws -> [O] {
        return try objectContext.performAndWait {
            let dataBaseModels = try self.objectContext.fetch(fetchReuqest)
            return dataBaseModels.map(mapClosure)
        }
    }
    
    func delete<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) throws {
        let objects = try objectContext.fetch(fetchRequest)

        try objectContext.performAndWait {
            for object in objects {
                self.objectContext.delete(object)
            }

            try self.save()
        }
    }
    
    private func save() throws {
        if objectContext.hasChanges {
            try objectContext.save()
        }
    }
}
