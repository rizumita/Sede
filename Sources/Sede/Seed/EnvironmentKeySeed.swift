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

    public func value(environment: EnvironmentValues) -> Key.Value {
        environment[Key]
    }

    public func seed(environment: EnvironmentValues) -> Seed<Key.Value> {
        let value = environment[Key]
        return Seed(objectWillChange: value.objectWillChange.map { _ in }) { environment[Key] }
    }
}
