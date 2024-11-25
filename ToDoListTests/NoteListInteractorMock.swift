//
//  NoteListInteractorMock.swift
//  ToDoListTests
//
//  Created by Margarita Slesareva on 24.11.2024.
//

import Foundation
@testable import ToDoList

class NoteListInteractorMock: NoteListInteractor {
    
    private(set) var getNotesCalledCount = 0
    
    func getNotes(completion: @escaping (Result<[ToDoList.NoteModel], ToDoList.RequestError>) -> Void) {
        getNotesCalledCount += 1
        
        let models = [NoteModel]()
        completion(.success(models))
    }
    
    func deleteNote(id: UUID) {
        
    }
}
