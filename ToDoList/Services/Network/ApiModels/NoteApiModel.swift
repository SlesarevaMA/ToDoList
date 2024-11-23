//
//  NoteApiModel.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 20.11.2024.
//

import Foundation


struct NoteApiModel: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
