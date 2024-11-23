//
//  NoteListViewModel.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 20.11.2024.
//

import Foundation


struct NoteListViewModel {
    let id: UUID
    let title: String
    let description: String
    let completed: Bool
    let dateString: String
}
