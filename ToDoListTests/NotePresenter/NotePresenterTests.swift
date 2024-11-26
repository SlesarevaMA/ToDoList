//
//  NotePresenterTests.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

import Foundation
import Testing
@testable import ToDoList


struct NotePresenterTests {
    private var notePresenter: NotePresenter
    
    private let noteInteractorMock = NoteInteractorMock()
    private let noteViewInputMock = NoteViewInputMock()
    
    init() {
        notePresenter = NotePresenter(
            interactor: noteInteractorMock,
            presenterQueue: DispatchQueueMock(),
            mainQueue: DispatchQueueMock()
        )
        notePresenter.view = noteViewInputMock
    }
    
    @Test
    func viewDidLoad_configureExistingModelCalled() {
        // given
        let uuid = UUID()
        notePresenter.setModelId(uuid)
        noteInteractorMock.fetchNoteFromIdReturnValue = NoteModel(
            id: uuid,
            completed: true,
            title: "",
            description: "",
            date: Date()
        )
        
        // when
        notePresenter.viewDidLoad()
        
        // then
        #expect(noteViewInputMock.configureCalledCount == 1)
        #expect(noteInteractorMock.fetchNoteFromIdArgumentValue == uuid)
    }

    @Test
    func viewDidLoad_configureNewModelCalled() {
        // given
        notePresenter.setModelId(nil)
        
        // when
        notePresenter.viewDidLoad()
        
        // then
        #expect(noteViewInputMock.configureCalledCount == 1)
    }
    
    @Test
    func viewDidLoad_setFocusOnTitleCalled() {
        // given
        notePresenter.setModelId(nil)
        
        // when
        notePresenter.viewDidLoad()
        
        // then
        #expect(noteViewInputMock.setFocusOnTitleCalledCount == 1)
    }
    
    @Test
    func viewDidLoad_setFocusOnDescriptionCalled() {
        // given
        notePresenter.setModelId(UUID())
        noteInteractorMock.fetchNoteFromIdReturnValue = NoteModel(
            id: UUID(),
            completed: true,
            title: "",
            description: "",
            date: Date()
        )
        
        // when
        notePresenter.viewDidLoad()
        
        // then
        #expect(noteViewInputMock.setFocusOnDescriptionCalledCount == 1)
    }
    
    @Test
    func viewWillDisappear_saveChangesCalled() {
        // when
        notePresenter.viewWillDisappear()
        
        // then
        #expect(noteInteractorMock.saveChangesCalledCount == 1)
    }
}
