//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct MappedSeed<T, U>: SeedProtocol {
    private var _seed: (EnvironmentValues) -> Seed<U>

    init<S: SeedProtocol>(_ s: S, keyPath: KeyPath<T, U>) where S.T == T {
        _seed = { environment in
            let baseSeed = s.seed(environment: environment)
            return Seed(objectWillChange: baseSeed.objectWillChange) { baseSeed._value[keyPath: keyPath] }
        }
    }

    init<S: SeedProtocol>(_ s: S, map: @escaping (T, EnvironmentValues) -> U) where S.T == T {
        _seed = { environment in
            let baseSeed = s.seed(environment: environment)
            return Seed(objectWillChange: baseSeed.objectWillChange) { map(baseSeed._value, environment) }
        }
    }

    public func value(environment: EnvironmentValues) -> U { fatalError() }

    public func seed(environment: EnvironmentValues) -> Seed<U> {
        _seed(environment)
    }
}
