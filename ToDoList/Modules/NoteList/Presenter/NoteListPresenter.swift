//
//  NoteListPresenter.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//


import Foundation

protocol NoteListInteractorOutput: AnyObject {
    
}


protocol NoteListViewOutput: AnyObject {
    var view: NoteListViewInput? { get set }
    var router: Router? { get set }
    
    func viewWillAppear()
    func cellDidTap(model: NoteListViewModel)
}

final class NoteListPresenter: NoteListViewOutput {
    weak var view: NoteListViewInput?
    weak var router: Router?
    
    private let interactor: NoteListInteractor
    
    init(interactor: NoteListInteractor) {
        self.interactor = interactor
    }
    
    func viewWillAppear() {
        interactor.getNotes { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let noteModels):
                let viewModels = self.mapNoteListViewModels(noteModels)
                
                DispatchQueue.main.async {
                    self.view?.addNotes(models: viewModels)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func rightBarButtonItemTapped() {
//        router?.showNote(model: NoteViewModel)
    }
        
    func cellDidTap(model: NoteListViewModel) {
        let noteViewModel = mapNoteViewModel(noteListViewModel: model)
        
        router?.showNote(model: noteViewModel)
    }
    
    private func mapNoteViewModel(noteListViewModel: NoteListViewModel) -> NoteViewModel {
        return NoteViewModel(
            id: noteListViewModel.id,
            title: noteListViewModel.title,
            dateString: noteListViewModel.dateString,
            description: noteListViewModel.description
        )
    }
    
    private func mapNoteListViewModels(_ models: [NoteModel]) -> [NoteListViewModel] {
        let viewModels = models.map { model in
            
            let dateString = model.date.formatted(date: .abbreviated, time: .omitted)
            
            return NoteListViewModel(
                id: model.id,
                title: model.title,
                description: model.description,
                completed: model.completed,
                dateString: dateString
            )
        }
        
        return viewModels
    }
}
