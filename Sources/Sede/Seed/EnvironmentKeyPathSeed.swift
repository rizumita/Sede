//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct EnvironmentKeyPathSeed<Value: ObservableObject>: SeedProtocol {
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

    public func seed(environment: EnvironmentValues) -> Seed<Value> {
        let value = environment[keyPath: keyPath]
        return Seed(objectWillChange: value.objectWillChange,
                    initialize: { environment[keyPath: keyPath] },
                    update: { update(value: $0, environment: environment) })
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public func seeded<Value: ObservableObject>(_ keyPath: KeyPath<EnvironmentValues, Value>) -> EnvironmentKeyPathSeed<Value> {
    EnvironmentKeyPathSeed(keyPath)
}
