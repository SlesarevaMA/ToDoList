//
//  UserDefaultsMock.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//


@testable import ToDoList
import Foundation


class UserDefaultsMock: UserDefaultsType {
    
    var boolForKeyReturnValue = false
    
    func bool(forKey defaultName: String) -> Bool {
        return boolForKeyReturnValue
    }
    
    func set(_ value: Bool, forKey defaultName: String) {

    }
}
