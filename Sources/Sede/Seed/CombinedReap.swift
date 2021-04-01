//
// Created by 和泉田 領一 on 2021/03/20.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CombinedReap<Value>: ReapProtocol {
    private var _reap: (EnvironmentValues) -> AnyReap<Value>

    public init<S1: ReapProtocol,
               S2: ReapProtocol>(_ s1: S1,
                                 _ s2: S2,
                                 initialize: @escaping (S1.Value,
                                                        S2.Value,
                                                        EnvironmentValues) -> Value,
                                 update: @escaping (Value,
                                                    S1.Value,
                                                    S2.Value,
                                                    EnvironmentValues) -> Value = { value, _, _, _ in value }) {
        _reap = { environment in
            let reap1 = s1.reap(environment: environment)
            let reap2 = s2.reap(environment: environment)
            return AnyReap(objectWillChange: Publishers.MergeMany(reap1.objectWillChange,
                                                               reap2.objectWillChange),
                        initialize: { initialize(reap1._value, reap2._value, environment) },
                        update: { value in update(value, reap1._value, reap2._value, environment) })
        }
    }

    public init<S1: ReapProtocol,
               S2: ReapProtocol,
               S3: ReapProtocol>(_ s1: S1,
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
        _reap = { environment in
            let reap1 = s1.reap(environment: environment)
            let reap2 = s2.reap(environment: environment)
            let reap3 = s3.reap(environment: environment)

            return AnyReap(
                objectWillChange: Publishers.MergeMany(reap1.objectWillChange,
                                                       reap2.objectWillChange,
                                                       reap3.objectWillChange),
                initialize: { initialize(reap1._value, reap2._value, reap3._value, environment) },
                update: { value in update(value, reap1._value, reap2._value, reap3._value, environment) })
        }
    }

    public init<S1: ReapProtocol,
               S2: ReapProtocol,
               S3: ReapProtocol,
               S4: ReapProtocol>(_ s1: S1,
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
        _reap = { environment in
            let reap1 = s1.reap(environment: environment)
            let reap2 = s2.reap(environment: environment)
            let reap3 = s3.reap(environment: environment)
            let reap4 = s4.reap(environment: environment)

            return AnyReap(
                objectWillChange: Publishers.MergeMany(reap1.objectWillChange,
                                                       reap2.objectWillChange,
                                                       reap3.objectWillChange,
                                                       reap4.objectWillChange),
                initialize: { initialize(reap1._value, reap2._value, reap3._value, reap4._value, environment) },
                update: { value in update(value, reap1._value, reap2._value, reap3._value, reap4._value, environment) })
        }
    }

    public func initialize(environment: EnvironmentValues) -> Value {
        fatalError()
    }

    public func update(value: Value, environment: EnvironmentValues) -> Value {
        fatalError()
    }

    public func reap(environment: EnvironmentValues) -> AnyReap<Value> { _reap(environment) }
}
