//
//  DispatchQueueMock.swift
//  ToDoListTests
//
//  Created by Margarita Slesareva on 24.11.2024.
//

@testable import ToDoList
import Foundation

class DispatchQueueMock: DispatchQueueType {
    func async(
        group: DispatchGroup?,
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @Sendable @convention(block) () -> Void
    ) {
        work()
    }
}
