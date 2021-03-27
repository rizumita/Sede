//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol SeedProtocol {
    associatedtype Value

    func initialize(environment: EnvironmentValues) -> Value

    func update(value: Value, environment: EnvironmentValues) -> Value

    func seed(environment: EnvironmentValues) -> Seed<Value>
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SeedProtocol {
    func map<NewValue>(_ keyPath: KeyPath<Value, NewValue>) -> MappedSeed<Value, NewValue> {
        MappedSeed(self, keyPath: keyPath)
    }

    func map<NewValue>(_ f: @escaping (Value, EnvironmentValues) -> NewValue) -> MappedSeed<Value, NewValue> {
        MappedSeed(self, map: f)
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SeedProtocol {
    func seed(environment: EnvironmentValues) -> Seed<Value> {
        Seed(objectWillChange: Empty<(), Never>(completeImmediately: false),
             initialize: { initialize(environment: environment) },
             update: { update(value: $0, environment: environment) })
    }
}
