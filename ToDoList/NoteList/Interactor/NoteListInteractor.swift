//
//  NoteListInteractor.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//


protocol NoteListInteractorOutput: AnyObject {
    
}

protocol NoteListInteractor: AnyObject {
    
}

final class NoteListInteractorImpl: NoteListInteractor {
    
    weak var output: NoteListInteractorOutput?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
