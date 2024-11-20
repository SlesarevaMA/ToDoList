//
//  NoteListApiModel.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 20.11.2024.
//

import Foundation


struct NoteListApiModel: Decodable {
    let todos: [NoteApiModel]
    let total: Int
    let skip: Int
    let limit: Int
}
