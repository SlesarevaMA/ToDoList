//
//  NoteInteractor.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 22.11.2024.
//

import Foundation

protocol NoteInteractor: AnyObject {
    func saveChanges(for modelId: Int, changes: (title: String, description: String))
}

final class NoteInteractorImpl: NoteInteractor {
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func saveChanges(for modelId: Int, changes: (title: String, description: String)) {
        do {
            let fetchRequest = DBNote.fetchRequest()
            let predicate = NSPredicate(format: "id == %d", modelId)
            fetchRequest.predicate = predicate

            try coreDataManager.save { context in
                let dbModels = try? context.fetch(fetchRequest)

                if let dbModel = dbModels?.first {
                    dbModel.title = changes.title
                    dbModel.body = changes.description
                }
            }
        } catch {
            print("Edit note error: \(error)")
        }
    }
}
