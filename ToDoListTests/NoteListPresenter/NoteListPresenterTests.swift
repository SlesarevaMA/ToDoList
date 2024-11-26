//
//  NoteListPresenterTests.swift
//  ToDoListTests
//
//  Created by Margarita Slesareva on 24.11.2024.
//

import Testing
@testable import ToDoList
import Foundation

struct NoteListPresenterTests {

    private var noteListPresenter: NoteListPresenter
    
    private let noteListInteractorMock = NoteListInteractorMock()
    private let noteListViewInputMock = NoteListViewInputMock()
    private let routerMock = RouterMock()
    
    init() {
        noteListPresenter = NoteListPresenter(
            interactor: noteListInteractorMock,
            presenterQueue: DispatchQueueMock(),
            mainQueue: DispatchQueueMock()
        )
        
        noteListPresenter.view = noteListViewInputMock
        noteListPresenter.router = routerMock
    }
    
    @Test
    func viewWillApear_getNotesCalled() {
        // given
        
        // when
        noteListPresenter.viewIsAppearing()
        
        // then
        #expect(noteListInteractorMock.getNotesCalledCount == 1)
    }
    
    @Test
    func viewWillApear_addNotesCalled() {
        // when
        noteListPresenter.viewIsAppearing()
        
        // then
        #expect(noteListViewInputMock.addNotesCalledCount == 1)
    }
    
    @Test
    func completeChanged_editNoteCalled() {
        // given
        let uuid = UUID()
        let completed = true
        
        // when
        noteListPresenter.completeChanged(id: uuid, completed: completed)
        
        // then
        #expect(noteListInteractorMock.editNoteCalledCount == 1)
    }
    
    @Test
    func rightBarButtonItemTapped_showNoteCalled() {
        // when
        noteListPresenter.rightBarButtonItemTapped()
        
        // then
        #expect(routerMock.showNoteCalledCount == 1)
    }
    
    @Test
    func didTapCell_showNoteListCalled() {
        // given
        let uuid = UUID()
        
        // when
        noteListPresenter.didTapCell(id: uuid)
        
        // then
        #expect(routerMock.showNoteCalledCount == 1)
    }
    
    @Test
    func firstActionTapped_showNoteCalled() {
        // given
        let uuid = UUID()
        
        // when
        noteListPresenter.firstActionTapped(id: uuid)
        
        // then
        #expect(routerMock.showNoteCalledCount == 1)
    }
    
    @Test
    func thirdActionTapped_deleteNoteCalled() {
        // given
        let uuid = UUID()
        
        // when
        noteListPresenter.thirdActionTapped(id: uuid)
        
        // then
        #expect(noteListInteractorMock.deleteNoteCalledCount == 1)
    }
}
