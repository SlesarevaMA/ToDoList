//
//  UITableView+.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 20.11.2024.
//

import UIKit


extension UITableView {
    func register<T: CellIdentifiable>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeReusableCell<T: CellIdentifiable>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(T.self) for indexPath: \(indexPath)")
        }

        return cell
    }
}
