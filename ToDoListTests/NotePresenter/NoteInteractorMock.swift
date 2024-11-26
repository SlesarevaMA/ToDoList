//
//  NoteInteractorMock.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

import Testing
@testable import ToDoList
import Foundation


class NoteInteractorMock: NoteInteractor {
    
    var fetchNoteFromIdReturnValue: NoteModel?
    
    private(set) var saveChangesCalledCount = 0
    
    func saveChanges(for modelId: UUID?, title: String, description: String) {
        saveChangesCalledCount += 1
    }
    
    func fetchNote(from id: UUID) -> NoteModel? {        
        return fetchNoteFromIdReturnValue
    }
}
