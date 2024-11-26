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
    private(set) var setFocusOnTitleCalledCount = 0
    private(set) var setFocusOnDescriptionCalledCount = 0

    
    func configure(with model: NoteViewModel) {
        configureCalledCount += 1
    }
    
    func setFocusOnTitle() {
        setFocusOnTitleCalledCount += 1
    }
    
    func setFocusOnDescription() {
        setFocusOnDescriptionCalledCount += 1
    }
}
