//
//  NoteInteractor.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 22.11.2024.
//

import Foundation

protocol NoteInteractor: AnyObject {
    func saveChanges(for modelId: Int?, title: String, description: String)
    func fetchNote(from id: Int) -> NoteModel?
}

final class NoteInteractorImpl: NoteInteractor {
    private let coreDataManager: CoreDataManager
    private let userDefaults: UserDefaults
    
    init(coreDataManager: CoreDataManager, userDefaults: UserDefaults) {
        self.coreDataManager = coreDataManager
        self.userDefaults = userDefaults
    }
    
    func fetchNote(from id: Int) -> NoteModel? {
        do {
            let fetchRequest = DBNote.fetchRequest()
            let predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.predicate = predicate
            
            let models = try coreDataManager.read(fetchReuqest: fetchRequest) {
                return NoteModel(
                    id: Int($0.id),
                    completed: $0.completed,
                    title: $0.title,
                    description: $0.body,
                    date: $0.date
                )
            }
            
            guard let model = models.first else {
                fatalError("Read DB error")
            }
            
            return model
        } catch {
            print("Edit note error: \(error)")
            return nil
        }
    }
    
    func saveChanges(for modelId: Int?, title: String, description: String) {
        if let modelId {
            editNote(for: modelId, title: title, description: description)
        } else {
            let lastId = userDefaults.integer(forKey: "LastId")
            userDefaults.set(lastId + 1, forKey: "LastId")
            createNewNote(for: lastId + 1, title: title, description: description)
        }
    }
    
    private func createNewNote(for modelId: Int, title: String, description: String) {
        do {
            try coreDataManager.save { context in
                let dbModel = DBNote(context: context)
                dbModel.id = Int64(modelId)
                dbModel.title = title
                dbModel.body = description
                dbModel.completed = false
                dbModel.date = Date()
            }
        } catch {
            print("Add note error: \(error)")
        }
    }
    
    private func editNote(for modelId: Int, title: String, description: String) {
        do {
            let fetchRequest = DBNote.fetchRequest()
            let predicate = NSPredicate(format: "id == %d", modelId)
            fetchRequest.predicate = predicate

            try coreDataManager.save { context in
                let dbModels = try? context.fetch(fetchRequest)

                if let dbModel = dbModels?.first {
                    dbModel.title = title
                    dbModel.body = description
                }
            }
        } catch {
            print("Edit note error: \(error)")
        }
    }
}
