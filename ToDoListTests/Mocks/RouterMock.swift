//
//  RouterMock.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//


import Foundation
@testable import ToDoList


class RouterMock: Router {
    
    private(set) var showNoteCalledCount = 0

    
    func showNoteList() {

    }
    
    func showNote(id: UUID?) {
        showNoteCalledCount += 1
    }
}
