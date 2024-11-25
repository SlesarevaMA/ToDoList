//
//  NoteListInteractorTests.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

import Testing
@testable import ToDoList
import Foundation


struct NoteListInteractorTests {
    
    private var noteListInteractor: NoteListInteractorImpl
    
    private let coreDataManagerMock = CoreDataManagerMock()
    private let networkServiceMock = NetworkServiceMock()
    private let userDefaultsMock = UserDefaultsMock()
    
    init() {
        noteListInteractor = NoteListInteractorImpl(
            networkService: networkServiceMock,
            coreDataManager: coreDataManagerMock,
            userDefaults: userDefaultsMock
        )
    }
    
    @Test
    func getNotes_readCalled() {
        // given
        userDefaultsMock.boolForKeyReturnValue = true
        let completion: (Result<[NoteModel], RequestError>) -> Void = { _ in }
        
        // when
        noteListInteractor.getNotes(completion: completion)
        
        // then
        #expect(coreDataManagerMock.readCalledCount == 1)
    }
    
    @Test
    func getNotesOnFirstLaunch_sendRequestCalled() {
        // given
        userDefaultsMock.boolForKeyReturnValue = false
        let completion: (Result<[NoteModel], RequestError>) -> Void = { _ in }
        
        // when
        noteListInteractor.getNotes(completion: completion)
        
        // then
        #expect(networkServiceMock.sendRequestCalledCount == 1)
    }
    
    @Test
    func deleteNote_deleteCalled() {
        // given
        let uuid = UUID()
        
        // when
        noteListInteractor.deleteNote(id: uuid)
        
        // then
        #expect(coreDataManagerMock.deleteCalledCount == 1)
    }
}
