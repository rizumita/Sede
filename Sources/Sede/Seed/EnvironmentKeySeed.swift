//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias EnvKeySeed<Key: EnvironmentKey> = EnvironmentKeySeed<Key> where Key.Value: ObservableObject

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct EnvironmentKeySeed<Key: EnvironmentKey>: SeedProtocol where Key.Value: ObservableObject {
    public init() {}

    public func initialize(environment: EnvironmentValues) -> Key.Value {
        environment[Key]
    }

    public func update(value: Value, environment: EnvironmentValues) -> Value {
        environment[Key]
    }

    public func seed(environment: EnvironmentValues) -> Seed<Key.Value> {
        let value = environment[Key]
        return Seed<Key.Value>(objectWillChange: value.objectWillChange,
                               initialize: { initialize(environment: environment) },
                               update: { update(value: $0, environment: environment) })
    }
}
