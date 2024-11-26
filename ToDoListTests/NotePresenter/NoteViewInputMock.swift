//
//  NoteViewInputMock.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

@testable import ToDoList


class NoteViewInputMock: NoteViewInput {
    
    var currentText: String = ""
    
    var currentDescription: String = ""
    
    private(set) var configureCalledCount = 0
    
    func configure(with model: ToDoList.NoteViewModel) {
        configureCalledCount += 1
    }
    
    func setFocusOnTitle() {
        
    }
    
    func setFocusOnDescription() {
        
    }
}
