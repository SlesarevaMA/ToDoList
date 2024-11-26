//
//  NoteListRequest.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//

import Foundation


struct NoteListRequest: Request {
    var urlRequest: URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "dummyjson.com"
        urlComponents.path = "/todos"
        
        guard let url = urlComponents.url else {
            fatalError("not valid url")
        }
        
        return URLRequest(url: url)
    }
}
