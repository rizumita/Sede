//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol SeedProtocol {
    associatedtype T

    func value(environment: EnvironmentValues) -> T

    func seed(environment: EnvironmentValues) -> Seed<T>
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SeedProtocol {
    func map<Value>(_ keyPath: KeyPath<T, Value>) -> MappedSeed<T, Value> {
        MappedSeed(self, keyPath: keyPath)
    }

    func map<Value>(_ f: @escaping (T, EnvironmentValues) -> Value) -> MappedSeed<T, Value> {
        MappedSeed(self, map: f)
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SeedProtocol {
    func seed(environment: EnvironmentValues) -> Seed<T> {
        Seed(objectWillChange: Empty<(), Never>(completeImmediately: false)) { value(environment: environment) }
    }
}
