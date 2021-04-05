//
//  AnyReap.swift
//  Sede
//
//  Created by Ryoichi Izumita on 2021/03/10.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class AnyReaped<Value>: Reapable, ObservableObject {
    private var _initialize: () -> Value
    private var _update: (Value) -> Value
    private var cancellables = Set<AnyCancellable>()

    var value: Value?

    public let observedObjects: [AnyObservableObject]

    public init(initialize: @escaping () -> Value, update: @escaping (Value) -> Value = { $0 }) {
        _initialize = initialize
        _update = update
        observedObjects = []
    }

    init<R: Reapable>(_ reap: R) where R.Value == Value {
        _initialize = reap.initialize
        _update = reap.update(value:)
        observedObjects = reap.observedObjects
    }

    public func initialize() -> Value {
        let value = _initialize()
        anyObjectWillChange.receive(on: RunLoop.main)
            .sink { [weak self] in self?.objectWillChange.send() }
            .store(in: &cancellables)
        return value
    }

    public func update(value: Value) -> Value { _update(value) }
}
