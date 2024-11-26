//
//  Router.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 21.11.2024.
//

import UIKit


protocol Router: AnyObject {
    func showNoteList()
    func showNote(id: UUID?)
}

final class RouterImpl: Router {
    private let navigationController: UINavigationController
    private let assembly: Assembly
    
    init(navigationController: UINavigationController, assembly: Assembly) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func showNoteList() {
        let noteListInteractor = NoteListInteractorImpl(
            networkService: assembly.networkService,
            coreDataManager: assembly.coreDataManager,
            userDefaults: assembly.userDefaults
        )
        
        let presenterQueue = DispatchQueue(
            label: "com.ritulya.notelistpresenter",
            // Чтобы не создавать новый поток, а брать из пула потоков (non overcommit).
            target: .global(qos: .userInitiated)
        )
        
        let noteListPresenter = NoteListPresenter(interactor: noteListInteractor, presenterQueue: presenterQueue)
        let noteListViewController = NoteListViewController(noteListViewOutput: noteListPresenter)
        
        noteListPresenter.view = noteListViewController
        noteListPresenter.router = self
        
        navigationController.setViewControllers([noteListViewController], animated: false)
    }
    
    func showNote(id: UUID?) {
        let noteInteractor = NoteInteractorImpl(coreDataManager: assembly.coreDataManager)
        
        let presenterQueue = DispatchQueue(
            label: "com.ritulya.noteresenter",
            target: .global(qos: .userInitiated)
        )
        
        let notePresenter = NotePresenter(interactor: noteInteractor, presenterQueue: presenterQueue)
        notePresenter.setModelId(id)
        
        let noteViewController = NoteViewController(output: notePresenter)
        notePresenter.view = noteViewController
        
        navigationController.pushViewController(noteViewController, animated: true)
    }
}
