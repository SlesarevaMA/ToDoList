//
//  DispatchQueueType.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 24.11.2024.
//

import Foundation

protocol DispatchQueueType: AnyObject {
    func async(
        group: DispatchGroup?,
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @Sendable @convention(block) () -> Void
    )
}

extension DispatchQueueType {
    func async(
        group: DispatchGroup? = nil,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping @Sendable @convention(block) () -> Void
    ) {
        async(group: group, qos: qos, flags: flags, execute: work)
    }
}

extension DispatchQueue: DispatchQueueType { }
