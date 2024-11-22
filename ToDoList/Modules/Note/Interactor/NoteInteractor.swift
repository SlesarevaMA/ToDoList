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
    private let userDefaults: UserDefaults
    
    init(coreDataManager: CoreDataManager, userDefaults: UserDefaults) {
        self.coreDataManager = coreDataManager
        self.userDefaults = userDefaults
    }
    
    func saveChanges(for modelId: Int, changes: (title: String, description: String)) {
        let lastId = userDefaults.integer(forKey: "LastId")
        
        if lastId == modelId {
            createNewNote(for: modelId, changes: changes)
        } else {
            editNote(for: modelId, changes: changes)
        }
    }
    
    private func createNewNote(for modelId: Int, changes: (title: String, description: String)) {
        do {
            try coreDataManager.save { context in
                let dbModel = DBNote(context: context)
                dbModel.id = Int64(modelId)
                dbModel.title = changes.title
                dbModel.body = changes.description
                dbModel.completed = false
                dbModel.date = Date()
            }
        } catch {
            print("Add note error: \(error)")
        }
    }
    
    private func editNote(for modelId: Int, changes: (title: String, description: String)) {
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
