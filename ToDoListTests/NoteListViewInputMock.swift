//
//  NoteListViewInputMock.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 24.11.2024.
//


@testable import ToDoList

class NoteListViewInputMock: NoteListViewInput {
    private(set) var addNotesCalledCount = 0
    
    func addNotes(models: [ToDoList.NoteListViewModel]) {
        addNotesCalledCount += 1
    }
}
