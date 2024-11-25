//
//  NotePresenterTests.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

import Testing
@testable import ToDoList

struct NotePresenterTests {
    private var notePresenter: NotePresenter
    
    private let noteInteractorMock = NoteInteractorMock()
    private let noteViewInputMock = NoteViewInputMock()
    
    init() {
        notePresenter = NotePresenter(interactor: noteInteractorMock, presenterQueue: DispatchQueueMock())
        notePresenter.view = noteViewInputMock
    }
    
    @Test
    func viewDidLoad_configure() {
        // given
        
        // when
        notePresenter.viewDidLoad()
        
        // then
        #expect(noteViewInputMock.configureCalledCount == 1)
    }
    
    @Test
    func viewWillDisappear_saveChanges() {
        // given
        
        // when
        notePresenter.viewWillDisappear()
        
        // then
        #expect(noteInteractorMock.saveChangesCalledCount == 1)
    }
}
