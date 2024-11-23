//
//  NotePresenter.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 22.11.2024.
//

import Foundation

protocol NoteViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillDisappear()
}

final class NotePresenter: NoteViewOutput {
    
    weak var view: NoteViewInput?
    
    private let interactor: NoteInteractor
    private let presenterQueue = DispatchQueue(
        label: "com.ritulya.noteresenter",
        target: .global(qos: .userInitiated)
    )
    
    private var modelId: UUID?
    
    init(interactor: NoteInteractor) {
        self.interactor = interactor
    }
    
    func setModelId(_ modelId: UUID?) {
        self.modelId = modelId
    }
    
    func viewDidLoad() {
        if let modelId {
            presenterQueue.async {
                guard let viewModel = self.getViewModel(modelId: modelId) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.view?.configure(with: viewModel)
                }
            }
        } else {
            let dateString = Date().formatted(date: .abbreviated, time: .omitted)
            view?.configure(with: NoteViewModel(title: "", dateString: dateString, description: "", completed: false))
        }
    }
    
    /// Сохраниям данные, даже если пользователь передумал закрывать экран.
    func viewWillDisappear() {
        guard let view else {
            return
        }
        
        let title = view.currentText
        let description = view.currentDescription
        
        presenterQueue.async {
            self.interactor.saveChanges(for: self.modelId, title: title, description: description)
        }
    }
    
    private func getViewModel(modelId: UUID) -> NoteViewModel? {
        guard let model = interactor.fetchNote(from: modelId) else {
            return nil
        }
        
        let dateString = model.date.formatted(date: .abbreviated, time: .omitted)
        
        let viewModel = NoteViewModel(
            title: model.title,
            dateString: dateString,
            description: model.description,
            completed: model.completed
        )
        
        return viewModel
    }
}
