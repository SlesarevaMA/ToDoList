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
    func viewWillAppear()
    func didTapCell(id: UUID)
    func rightBarButtonItemTapped()
}

final class NoteListPresenter {
    weak var view: NoteListViewInput?
    weak var router: Router?
    
    private let interactor: NoteListInteractor
    private let presenterQueue = DispatchQueue(
        label: "com.ritulya.notelistpresenter",
        target: .global(qos: .userInitiated)
    )
    
    init(interactor: NoteListInteractor) {
        self.interactor = interactor
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

extension NoteListPresenter: NoteListViewOutput {
    
    func viewWillAppear() {
        presenterQueue.async {
            self.interactor.getNotes { [weak self] result in
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
    }
    
    func rightBarButtonItemTapped() {
        router?.showNote(id: nil)
    }
        
    func didTapCell(id: UUID) {
        router?.showNote(id: id)
    }
}
