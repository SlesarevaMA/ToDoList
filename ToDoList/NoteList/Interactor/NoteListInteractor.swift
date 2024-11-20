//
//  NoteListInteractor.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//


//import CoreData
import Foundation

protocol NoteListInteractorOutput: AnyObject {
    
}

protocol NoteListInteractor: AnyObject {
    
}

struct NoteViewModel {
    let title: String
    let description: String
    let completed: Bool
    let dateString: String
}

struct NoteModel {
    let id: Int
    let completed: Bool
    let title: String
    let date: Date
}

final class NoteListInteractorImpl: NoteListInteractor {
    
    weak var output: NoteListInteractorOutput?
    
    private let networkService: NetworkService
    private let coreDataManager: CoreDataManager
    
    private var isFirstLaunch = false
    
    init(networkService: NetworkService, coreDataManager: CoreDataManager) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
    func getNotes(completion: @escaping (Result<[NoteModel], RequestError>) -> Void) {
        if isFirstLaunch {
            getNotesFromNetwork(completion: completion)
        } else {
            getNotesFromStorage(completion: completion)
        }
    }
    
    private func getNotesFromStorage(completion: @escaping (Result<[NoteModel], RequestError>) -> Void) {
        do {
            let fetchRequest = DBNote.fetchRequest()

            let models = try coreDataManager.read(fetchReuqest: fetchRequest, mapClosure: {
                return NoteModel(id: Int($0.id), completed: $0.completed, title: $0.title, date: $0.date)
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
                completion(.success(noteModels))
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        }
    }
    
    private func mapNoteModels(apiModel: NoteListApiModel) -> [NoteModel] {
        let result: [NoteModel] = apiModel.todos.map { apiModel in
            return NoteModel(
                id: apiModel.id,
                completed: apiModel.completed,
                title: apiModel.todo,
                date: Date()
            )
        }
        
        return result
    }
}
