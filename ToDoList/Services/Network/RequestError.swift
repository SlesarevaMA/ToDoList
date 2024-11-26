//
//  RequestError.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//

import Foundation


enum RequestError: Error {
    case wrongStatusCode
    case download
    case parse
    case dataBase
    
    var description: String {
        switch self {
        case .download:
            return "Download fail"
        case .parse:
            return "Parse fail"
        case .wrongStatusCode:
            return "Wrong status code"
        case .dataBase:
            return "Fetch models error"
        }
    }
}
