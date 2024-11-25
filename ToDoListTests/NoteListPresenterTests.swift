//
//  NoteListPresenterTests.swift
//  ToDoListTests
//
//  Created by Margarita Slesareva on 24.11.2024.
//

import Testing
@testable import ToDoList

struct NoteListPresenterTests {

    private var noteListPresenter: NoteListPresenter!
    
    private let noteListInteractorMock = NoteListInteractorMock()
    private let noteListViewInputMock = NoteListViewInputMock()
    
    init() {
        noteListPresenter = NoteListPresenter(
            interactor: noteListInteractorMock,
            presenterQueue: DispatchQueueMock(),
            mainQueue: DispatchQueueMock()
        )
        
        noteListPresenter.view = noteListViewInputMock
    }
    
    @Test
    func viewWillApear_getNotesCalled() {
        // given
        
        // when
        noteListPresenter.viewWillAppear()
        
        // then
        #expect(noteListInteractorMock.getNotesCalledCount == 1)
    }
    
    @Test
    func viewWillApear_addNotesCalled() {
        // when
        noteListPresenter.viewWillAppear()
        
        // then
        #expect(noteListViewInputMock.addNotesCalledCount == 1)
    }
}
