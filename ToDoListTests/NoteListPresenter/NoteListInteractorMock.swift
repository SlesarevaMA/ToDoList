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
    private(set) var deleteNoteCalledCount = 0
    private(set) var editNoteCalledCount = 0
    
    func getNotes(completion: @escaping (Result<[NoteModel], RequestError>) -> Void) {
        getNotesCalledCount += 1
        
        let models = [NoteModel]()
        completion(.success(models))
    }
    
    func deleteNote(id: UUID) {
        deleteNoteCalledCount += 1
    }
    
    func editNote(for modelId: UUID, completed: Bool) {
        editNoteCalledCount += 1
    }
}
