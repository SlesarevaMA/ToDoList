//
//  NetworkServiceMock.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 25.11.2024.
//

@testable import ToDoList


class NetworkServiceMock: NetworkService {
    private(set) var sendRequestCalledCount = 0
    
    func sendRequest<RequestModel>(
        type: RequestModel.Type,
        request: any ToDoList.Request,
        completion: @escaping (
            Result<RequestModel, ToDoList.RequestError>
        ) -> (Void)
    ) where RequestModel : Decodable {
        sendRequestCalledCount += 1
    }
}
