//
//  NetworkService.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//

import Foundation

protocol NetworkService: AnyObject {
    func sendRequest<RequestModel: Decodable>(
        request: Request,
        completion: @escaping (Result<RequestModel, RequestError>) -> (Void)
    )
}

final class NetworkServiceImpl: NetworkService {
    private let jsonDecoder: JSONDecoder
    private var session: URLSession

    init(jsonDecoder: JSONDecoder, session: URLSession = URLSession(configuration: .default)) {
        self.jsonDecoder = jsonDecoder
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self.session = session
    }
    
    func sendRequest<RequestModel: Decodable>(
        request: Request,
        completion: @escaping (Result<RequestModel, RequestError>) -> (Void)
    ) {
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request.urlRequest) { data, response, error in
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.wrongStatusCode))
                return
            }
            
            guard let data else {
                completion(.failure(.download))
                return
            }
            
            do {
                let requestModel = try self.jsonDecoder.decode(RequestModel.self, from: data)
                completion(.success(requestModel))
            } catch {
                completion(.failure(.parse))
            }
        }
        
        dataTask.resume()
    }
}
