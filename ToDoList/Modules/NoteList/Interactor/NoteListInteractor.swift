//
//  NoteListInteractor.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//


import Foundation


protocol NoteListInteractor: AnyObject {
    func getNotes(completion: @escaping (Result<[NoteModel], RequestError>) -> Void)
    func editNote(for modelId: UUID, completed: Bool)
    func deleteNote(id: UUID)
}

final class NoteListInteractorImpl: NoteListInteractor {    
    private let networkService: NetworkService
    private let coreDataManager: CoreDataManager
    private let userDefaults: UserDefaultsType
            
    init(networkService: NetworkService, coreDataManager: CoreDataManager, userDefaults: UserDefaultsType) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
        self.userDefaults = userDefaults
    }
    
    func getNotes(completion: @escaping (Result<[NoteModel], RequestError>) -> Void) {
        let isFirstLaunch = !userDefaults.bool(forKey: "isNotFirstLaunch")

        if isFirstLaunch {
            getNotesFromNetwork(completion: completion)
        } else {
            getNotesFromStorage(completion: completion)
        }
        
        userDefaults.set(true, forKey: "isNotFirstLaunch")
    }
    
    func deleteNote(id: UUID) {
        do {
            let fetchRequest = DBNote.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as NSUUID)
            fetchRequest.predicate = predicate
            
            try coreDataManager.delete(for: fetchRequest)
        } catch {
            print("Delete model error: \(error)")
        }
    }
    
    func editNote(for modelId: UUID, completed: Bool) {
        do {
            let fetchRequest = DBNote.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", modelId as NSUUID)
            fetchRequest.predicate = predicate

            try coreDataManager.save { context in
                let dbModels = try? context.fetch(fetchRequest)

                if let dbModel = dbModels?.first {
                    dbModel.completed = completed
                }
            }
        } catch {
            print("Edit note error: \(error)")
        }
    }
        
    private func getNotesFromStorage(completion: @escaping (Result<[NoteModel], RequestError>) -> Void) {
        do {
            let fetchRequest = DBNote.fetchRequest()

            let models = try coreDataManager.read(
                fetchReuqest: fetchRequest,
                mapClosure: {
                    return NoteModel(
                        id: $0.id,
                        completed: $0.completed,
                        title: $0.title,
                        description: $0.body,
                        date: $0.date
                    )
            })

            completion(.success(models))
        } catch {
            print("Fetch models error: \(error)")
            completion(.failure(.dataBase))
        }
    }
    
    private func getNotesFromNetwork(completion: @escaping (Result<[NoteModel], RequestError>) -> Void) {
        let notesRequest = NoteListRequest()
                
        networkService.sendRequest(type: NoteListApiModel.self, request: notesRequest) { result in
            switch result {
            case .success(let apiModel):
                let noteModels = self.mapNoteModels(apiModel: apiModel)
                self.saveToStorage(noteModels: noteModels)
                
                completion(.success(noteModels))
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        }
    }
    
    private func mapNoteModels(apiModel: NoteListApiModel) -> [NoteModel] {
        let result: [NoteModel] = apiModel.todos.map { apiModel in
            return NoteModel(
                id: UUID(),
                completed: apiModel.completed,
                title: apiModel.todo,
                description: "",
                date: Date()
            )
        }
        
        return result
    }
    
    private func saveToStorage(noteModels: [NoteModel]) {
        do {
            try coreDataManager.save { context in
                context.performAndWait {
                    for model in noteModels {
                        let note = DBNote(context: context)
                        note.id = model.id
                        note.title = model.title
                        note.body = model.description
                        note.date = model.date
                        note.completed = model.completed
                    }
                }
            }
        } catch {
            print("Save notes error \(error)")
        }
    }
}
