//
//  NoteListInteractor.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//


import CoreData

protocol NoteListInteractorOutput: AnyObject {
    
}

protocol NoteListInteractor: AnyObject {
    
}

struct NoteViewModel {
    let title: String
    let completed: Bool
    let dateString: String
}

struct Note {
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
    
    func getNotes() -> [Note] {
       return getNotesFromStorage()
    }
    
    private func getNotesFromStorage() -> [Note] {
        do {
            let fetchRequest = DBNote.fetchRequest()

            let models = try coreDataManager.read(fetchReuqest: fetchRequest, mapClosure: {
                return Note(id: Int($0.id), completed: $0.completed, title: $0.title, date: $0.date)
            })

            return models
        } catch {
            print("Fetch treatments models error: \(error)")
        }

        return []
    }
    
    private func getNotesFromNetwork() {
        let notesRequest = NoteListRequest()
        
        let notes: [Note] = networkService.sendRequest(request: notesRequest) { <#Result<Decodable, RequestError>#> in
            <#code#>
        }
    }
}
