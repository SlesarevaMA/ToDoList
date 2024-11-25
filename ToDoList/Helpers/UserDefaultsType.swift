//
//  UserDefaultsType.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

import Foundation

protocol UserDefaultsType {
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Bool, forKey defaultName: String)
}

extension UserDefaultsType {
    func bool(forKey defaultName: String) -> Bool {
        return bool(forKey: defaultName)
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        set(value, forKey: defaultName)
    }
}


extension UserDefaults: UserDefaultsType { }
