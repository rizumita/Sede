//
//  SedeProtocol.swift
//  Sede
//
//  Created by Ryoichi Izumita on 2021/03/10.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@dynamicMemberLookup
public class Seed<Value>: UpdatableObject {
    @Published public var _value: Value {
        willSet { _objectWillChange.send() }
    }
    public var objectWillChange: AnyPublisher<(), Never> {
        _objectWillChange.subscribe(on: RunLoop.main)
            .filter { [weak self] in self?.isSilent == false }
            .eraseToAnyPublisher()
    }

    let initialize: () -> Value
    let updateValue: (Value) -> Value
    private var isSilent = false
    private var isBaseUpdated = false
    private var _objectWillChange = PassthroughSubject<(), Never>()
    private var cancellables = Set<AnyCancellable>()

    public init(initialize: @escaping () -> Value, update: @escaping (Value) -> Value = { $0 }) {
        self._value = initialize()
        self.initialize = initialize
        self.updateValue = update
    }

    init<P: Publisher>(objectWillChange: P,
                       initialize: @escaping () -> Value,
                       update: @escaping (Value) -> Value) {
        self._value = initialize()
        self.initialize = initialize
        self.updateValue = update
        objectWillChange.assertNoFailure()
            .subscribe(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.isBaseUpdated = true
                self?._objectWillChange.send()
            }.store(in: &cancellables)
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<Value, U>) -> U {
        get { _value[keyPath: keyPath] }
        set { _value[keyPath: keyPath] = newValue }
    }

    public subscript<U>(dynamicMember keyPath: KeyPath<Value, U>) -> U {
        _value[keyPath: keyPath]
    }

    public func update() {
        guard isBaseUpdated else { return }

        defer {
            isSilent = false
            isBaseUpdated = false
        }

        isSilent = true
        _value = updateValue(_value)
    }
}
