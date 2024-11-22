//
//  NotePresenter.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 22.11.2024.
//

import Foundation

protocol NoteViewOutput: AnyObject {
    func viewDidDisappear(id: Int, title: String, description: String)
}

final class NotePresenter: NoteViewOutput {
    
    private let interactor: NoteInteractor
    
    init(interactor: NoteInteractor) {
        self.interactor = interactor
    }
    
    func viewDidDisappear(id: Int, title: String, description: String) {
        DispatchQueue.main.async {
            self.interactor.saveChanges(for: id, changes: (title: title, description: description))
        }
    }
}
