//
//  NoteListPresenter.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//

import Foundation


protocol NoteListViewOutput: AnyObject {
    func viewIsAppearing()
    func didTapCell(id: UUID)
    func completeChanged(id: UUID, completed: Bool)
    func rightBarButtonItemTapped()
    
    func firstActionTapped(id: UUID)
    func thirdActionTapped(id: UUID)
}

final class NoteListPresenter {
    weak var view: NoteListViewInput?
    var router: Router?
    
    private let interactor: NoteListInteractor
    private let presenterQueue: DispatchQueueType
    private let mainQueue: DispatchQueueType

    init(
        interactor: NoteListInteractor,
        presenterQueue: DispatchQueueType,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.interactor = interactor
        self.presenterQueue = presenterQueue
        self.mainQueue = mainQueue
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
    func viewIsAppearing() {
        presenterQueue.async {
            self.interactor.getNotes { [weak self] result in
                guard let self else {
                    return
                }
                
                switch result {
                case .success(let noteModels):
                    let noteModelsSorted = noteModels.sorted { $0.date > $1.date }
                    let viewModels = self.mapNoteListViewModels(noteModelsSorted)
                    
                    mainQueue.async {
                        self.view?.addNotes(models: viewModels)
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    func completeChanged(id: UUID, completed: Bool) {
        interactor.editNote(for: id, completed: completed)
    }
    
    func rightBarButtonItemTapped() {
        router?.showNote(id: nil)
    }
        
    func didTapCell(id: UUID) {
        router?.showNote(id: id)
    }
    
    func firstActionTapped(id: UUID) {
        router?.showNote(id: id)
    }
    
    func thirdActionTapped(id: UUID) {
        presenterQueue.async {
            self.interactor.deleteNote(id: id)
        }
    }
}
