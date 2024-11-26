//
//  CoreDataManagerMock.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

@testable import ToDoList
import CoreData


class CoreDataManagerMock: CoreDataManager {
    
    private(set) var saveCalledCount = 0
    private(set) var readCalledCount = 0
    private(set) var deleteCalledCount = 0
    
    func save(_ saveClosure: @escaping (NSManagedObjectContext) -> Void) throws {
        saveCalledCount += 1
    }
    
    func read<T, O>(
        fetchReuqest: NSFetchRequest<T>,
        mapClosure: @escaping (T) -> O
    ) throws -> [O] where T : NSFetchRequestResult {
        readCalledCount += 1
        return [O]()
    }
    
    func delete<T>(for fetchRequest: NSFetchRequest<T>) throws where T : NSManagedObject {
        deleteCalledCount += 1
    }
}
