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
    func viewDidLoad()
}

final class NoteListPresenter: NoteListViewOutput {
    weak var view: NoteListViewInput?
    
    private let interactor: NoteListInteractor
    
    init(interactor: NoteListInteractor) {
        self.interactor = interactor
    }
    
    func viewDidLoad() {
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
