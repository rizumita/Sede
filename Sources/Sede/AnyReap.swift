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
public class AnyReap<Value>: ObservableObject {
    var _value: Value {
        willSet {
            guard !isBaseUpdated else { return }
            print("send")
            objectWillChange.send()
        }
    }

    let updateValue: (Value) -> Value
    private var isBaseUpdated = false
    private var cancellables = Set<AnyCancellable>()

    public init(initialize: @escaping () -> Value, update: @escaping (Value) -> Value = { $0 }) {
        _value = initialize()
        updateValue = update
    }

    init<R: ReapProtocol>(_ reap: R, environment: EnvironmentValues) where R.Value == Value {
        _value = reap.initialize(environment: environment)
        updateValue = { reap.update(value: $0, environment: environment) }
        reap.objectWillChange
            .subscribe(on: RunLoop.main)
            .sink { [weak self] in
                self?.isBaseUpdated = true
                self?.objectWillChange.send()
            }.store(in: &cancellables)
    }

    init<R: ReapProtocol>(_ reap: R, environment: EnvironmentValues) where R.Value == Value, R.Value: ObservableObject {
        _value = reap.initialize(environment: environment)
        updateValue = { reap.update(value: $0, environment: environment) }
        Publishers.MergeMany(reap.objectWillChange, _value.objectWillChange.map { _ in }.eraseToAnyPublisher())
            .subscribe(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.isBaseUpdated = true
                self?.objectWillChange.send()
            }.store(in: &cancellables)
    }

    init<P: Publisher>(objectWillChange: P,
                       initialize: @escaping () -> Value,
                       update: @escaping (Value) -> Value) {
        _value = initialize()
        updateValue = update
        objectWillChange.assertNoFailure()
            .subscribe(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.isBaseUpdated = true
                self?.objectWillChange.send()
            }.store(in: &cancellables)
    }

    public func update() {
        guard isBaseUpdated else { return }

        defer { isBaseUpdated = false }

        _value = updateValue(_value)
    }
}
