//
//  NoteInteractor.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 22.11.2024.
//

import Foundation

protocol NoteInteractor: AnyObject {
    func saveChanges(for modelId: UUID?, title: String, description: String)
    func fetchNote(from id: UUID) -> NoteModel?
}

final class NoteInteractorImpl: NoteInteractor {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchNote(from id: UUID) -> NoteModel? {
        do {
            let fetchRequest = DBNote.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as NSUUID)
            fetchRequest.predicate = predicate
            
            let models = try coreDataManager.read(fetchReuqest: fetchRequest) {
                return NoteModel(
                    id: $0.id,
                    completed: $0.completed,
                    title: $0.title,
                    description: $0.body,
                    date: $0.date
                )
            }
            
            return models.first
        } catch {
            print("Edit note error: \(error)")
            return nil
        }
    }
    
    func saveChanges(for modelId: UUID?, title: String, description: String) {
        if let modelId {
            editNote(for: modelId, title: title, description: description)
        } else {
            createNewNote(for: UUID(), title: title, description: description)
        }
    }
    
    private func createNewNote(for modelId: UUID, title: String, description: String) {
        do {
            try coreDataManager.save { context in
                let dbModel = DBNote(context: context)
                dbModel.id = modelId
                dbModel.title = title
                dbModel.body = description
                dbModel.completed = false
                dbModel.date = Date()
            }
        } catch {
            print("Add note error: \(error)")
        }
    }
    
    private func editNote(for modelId: UUID, title: String, description: String) {
        do {
            let fetchRequest = DBNote.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", modelId as NSUUID)
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
