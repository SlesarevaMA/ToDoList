//
//  Assembly.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 21.11.2024.
//

import Foundation


final class Assembly {
    
    lazy var networkService: NetworkService = NetworkServiceImpl(jsonDecoder: jsonDecoder)
    let coreDataManager: CoreDataManager = CoreDataManagerImpl()

    private let jsonDecoder = JSONDecoder()
}
