//
//  NoteInteractorMock.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

import Testing
@testable import ToDoList
import Foundation


final class NoteInteractorMock: NoteInteractor {
    
    var fetchNoteFromIdReturnValue: NoteModel?
    var fetchNoteFromIdArgumentValue: UUID?
    
    private(set) var saveChangesCalledCount = 0
    
    func saveChanges(for modelId: UUID?, title: String, description: String) {
        saveChangesCalledCount += 1
    }
    
    func fetchNote(from id: UUID) -> NoteModel? {
        fetchNoteFromIdArgumentValue = id
        return fetchNoteFromIdReturnValue
    }
}
