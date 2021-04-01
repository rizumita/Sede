//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias EnvKeyReap<Key: EnvironmentKey> = EnvironmentKeyReap<Key> where Key.Value: ObservableObject

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct EnvironmentKeyReap<Key: EnvironmentKey>: ReapProtocol where Key.Value: ObservableObject {
    public init() {}

    public func initialize(environment: EnvironmentValues) -> Key.Value {
        environment[Key]
    }

    public func update(value: Value, environment: EnvironmentValues) -> Value {
        environment[Key]
    }

    public func reap(environment: EnvironmentValues) -> AnyReap<Key.Value> {
        AnyReap(self, environment: environment)
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentKeyReap: EnvironmentalObservableObjectProtocol {
    public func observable(environment: EnvironmentValues) -> AnyPublisher<(), Never> {
        initialize(environment: environment).objectWillChange.map { _ in }.eraseToAnyPublisher()
    }
}
