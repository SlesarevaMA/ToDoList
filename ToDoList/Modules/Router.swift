//
//  Router.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 21.11.2024.
//

import UIKit

protocol Router: AnyObject {
    func showNoteList()
    func showNote()
}

final class RouterImpl: Router {
    
    private let navigationController: UINavigationController
    private let assembly: Assembly
    
    init(navigationController: UINavigationController, assembly: Assembly) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func showNoteList() {
        let noteListInteractor: NoteListInteractor = NoteListInteractorImpl(
            networkService: assembly.networkService,
            coreDataManager: assembly.coreDataManager
        )
        
        let noteListPresenter: NoteListViewOutput = NoteListPresenter(interactor: noteListInteractor)
        let noteListViewController = NoteListViewController(noteListViewOutput: noteListPresenter)
        
        noteListPresenter.view = noteListViewController
        
        navigationController.setViewControllers([noteListViewController], animated: false)
    }
    
    func showNote() {
        
    }
}
