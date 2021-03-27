//
// Created by 和泉田 領一 on 2021/03/20.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CombinedSeed<Value>: SeedProtocol {
    private var _seed: (EnvironmentValues) -> Seed<Value>

    public init<S1: SeedProtocol,
               S2: SeedProtocol>(_ s1: S1,
                                 _ s2: S2,
                                 initialize: @escaping (S1.Value,
                                                        S2.Value,
                                                        EnvironmentValues) -> Value,
                                 update: @escaping (Value,
                                                    S1.Value,
                                                    S2.Value,
                                                    EnvironmentValues) -> Value = { value, _, _, _ in value }) {
        _seed = { environment in
            let seed1 = s1.seed(environment: environment)
            let seed2 = s2.seed(environment: environment)
            return Seed(objectWillChange: Publishers.MergeMany(seed1.objectWillChange,
                                                               seed2.objectWillChange),
                        initialize: { initialize(seed1._value, seed2._value, environment) },
                        update: { value in update(value, seed1._value, seed2._value, environment) })
        }
    }

    public init<S1: SeedProtocol,
               S2: SeedProtocol,
               S3: SeedProtocol>(_ s1: S1,
                                 _ s2: S2,
                                 _ s3: S3,
                                 initialize: @escaping (S1.Value,
                                                        S2.Value,
                                                        S3.Value,
                                                        EnvironmentValues) -> Value,
                                 update: @escaping (Value,
                                                    S1.Value,
                                                    S2.Value,
                                                    S3.Value,
                                                    EnvironmentValues) -> Value = { value, _, _, _, _ in value }) {
        _seed = { environment in
            let seed1 = s1.seed(environment: environment)
            let seed2 = s2.seed(environment: environment)
            let seed3 = s3.seed(environment: environment)

            return Seed(
                objectWillChange: Publishers.MergeMany(seed1.objectWillChange,
                                                       seed2.objectWillChange,
                                                       seed3.objectWillChange),
                initialize: { initialize(seed1._value, seed2._value, seed3._value, environment) },
                update: { value in update(value, seed1._value, seed2._value, seed3._value, environment) })
        }
    }

    public init<S1: SeedProtocol,
               S2: SeedProtocol,
               S3: SeedProtocol,
               S4: SeedProtocol>(_ s1: S1,
                                 _ s2: S2,
                                 _ s3: S3,
                                 _ s4: S4,
                                 initialize: @escaping (S1.Value,
                                                        S2.Value,
                                                        S3.Value,
                                                        S4.Value,
                                                        EnvironmentValues) -> Value,
                                 update: @escaping (Value,
                                                    S1.Value,
                                                    S2.Value,
                                                    S3.Value,
                                                    S4.Value,
                                                    EnvironmentValues) -> Value = { value, _, _, _, _, _ in value }) {
        _seed = { environment in
            let seed1 = s1.seed(environment: environment)
            let seed2 = s2.seed(environment: environment)
            let seed3 = s3.seed(environment: environment)
            let seed4 = s4.seed(environment: environment)

            return Seed(
                objectWillChange: Publishers.MergeMany(seed1.objectWillChange,
                                                       seed2.objectWillChange,
                                                       seed3.objectWillChange,
                                                       seed4.objectWillChange),
                initialize: { initialize(seed1._value, seed2._value, seed3._value, seed4._value, environment) },
                update: { value in update(value, seed1._value, seed2._value, seed3._value, seed4._value, environment) })
        }
    }

    public func initialize(environment: EnvironmentValues) -> Value {
        fatalError()
    }

    public func update(value: Value, environment: EnvironmentValues) -> Value {
        fatalError()
    }

    public func seed(environment: EnvironmentValues) -> Seed<Value> { _seed(environment) }
}
