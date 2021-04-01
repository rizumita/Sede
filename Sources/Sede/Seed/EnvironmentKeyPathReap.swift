//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct EnvironmentKeyPathReap<Value: ObservableObject>: ReapProtocol {
    private var keyPath: KeyPath<EnvironmentValues, Value>

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }

    public func initialize(environment: EnvironmentValues) -> Value {
        environment[keyPath: keyPath]
    }

    public func update(value: Value, environment: EnvironmentValues) -> Value {
        environment[keyPath: keyPath]
    }

    public func reap(environment: EnvironmentValues) -> AnyReap<Value> {
        let value = environment[keyPath: keyPath]
        return AnyReap(objectWillChange: value.objectWillChange,
                    initialize: { environment[keyPath: keyPath] },
                    update: { update(value: $0, environment: environment) })
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public func reaped<Value: ObservableObject>(_ keyPath: KeyPath<EnvironmentValues, Value>) -> EnvironmentKeyPathReap<Value> {
    EnvironmentKeyPathReap(keyPath)
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentKeyPathReap: EnvironmentalObservableObjectProtocol {
    public func observable(environment: EnvironmentValues) -> AnyPublisher<(), Never> {
        initialize(environment: environment).objectWillChange.map { _ in }.eraseToAnyPublisher()
    }
}
