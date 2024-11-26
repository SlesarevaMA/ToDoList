//
//  DispatchQueueType.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 24.11.2024.
//

import Foundation

/// Закрываем DispatchQueue протоколом, чтобы тестировать асинхронный код синхронно и не использовать expectations.
/// Таким образом тесты будут работать быстрее и не будут флакать.
protocol DispatchQueueType: AnyObject {
    func async(
        group: DispatchGroup?,
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @Sendable @convention(block) () -> Void
    )
    
    func asyncAfter(
        deadline: DispatchTime,
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
    
    func asyncAfter(
        deadline: DispatchTime,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping @Sendable @convention(block) () -> Void
    ) {
        asyncAfter(deadline: deadline, qos: qos, flags: flags, execute: work)
    }
}

extension DispatchQueue: DispatchQueueType { }
