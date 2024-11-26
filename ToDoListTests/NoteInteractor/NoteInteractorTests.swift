//
//  NoteInteractorTests.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

import Testing
import Foundation
import CoreData
@testable import ToDoList


struct NoteInteractorTests {
    private var noteInteractor: NoteInteractorImpl
    
    private let coreDataManagerMock = CoreDataManagerMock()
    
    init() {
        noteInteractor = NoteInteractorImpl(coreDataManager: coreDataManagerMock)
    }
    
    @Test
    func saveChanges_saveCalled() {
        // given
        let uuId = UUID()
        let title = ""
        let description = ""
        
        
        // when
        noteInteractor.saveChanges(for: uuId, title: title, description: description)
        
        // then
        #expect(coreDataManagerMock.saveCalledCount == 1)
    }
    
    @Test
    func fetchNote_readCalled() {
        // given
        let uuid = UUID()
        
        // when
        _ = noteInteractor.fetchNote(from: uuid)
        
        // then
        #expect(coreDataManagerMock.readCalledCount == 1)
    }
}
