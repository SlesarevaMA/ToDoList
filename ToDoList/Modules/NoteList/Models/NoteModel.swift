//
//  NoteModel.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 20.11.2024.
//

import Foundation


struct NoteModel {
    let id: UUID
    let completed: Bool
    let title: String
    let description: String
    let date: Date
}
