//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct MappedReap<T, U>: ReapProtocol {
    private var _reap: (EnvironmentValues) -> AnyReap<U>

    init<S: ReapProtocol>(_ s: S, keyPath: KeyPath<T, U>) where S.Value == T {
        _reap = { environment in
            let baseReap = s.reap(environment: environment)
            return AnyReap(objectWillChange: baseReap.objectWillChange,
                           initialize: { baseReap._value[keyPath: keyPath] },
                           update: { _ in baseReap.updateValue(baseReap._value)[keyPath: keyPath] })
        }
    }

    init<S: ReapProtocol>(_ s: S, map: @escaping (T, EnvironmentValues) -> U) where S.Value == T {
        _reap = { environment in
            let baseReap = s.reap(environment: environment)
            return AnyReap(objectWillChange: baseReap.objectWillChange,
                           initialize: { map(baseReap._value, environment) },
                           update: { _ in map(baseReap.updateValue(baseReap._value), environment) })
        }
    }

    public func initialize(environment: EnvironmentValues) -> U { fatalError() }

    public func update(value: U, environment: EnvironmentValues) -> U { fatalError() }

    public func reap(environment: EnvironmentValues) -> AnyReap<U> {
        _reap(environment)
    }
}
