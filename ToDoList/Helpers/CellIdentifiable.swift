//
//  CellIdentifiable.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 20.11.2024.
//

protocol CellIdentifiable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension CellIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
