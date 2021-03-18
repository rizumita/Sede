//
// Created by 和泉田 領一 on 2021/03/20.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CombinedSeed<Value: ObservableObject>: SeedProtocol {
    private var _seed: (EnvironmentValues) -> Seed<Value>

    public init<S1: SeedProtocol,
               S2: SeedProtocol>(_ s1: S1,
                                 _ s2: S2,
                                 combined: @escaping (S1.T,
                                                      S2.T,
                                                      EnvironmentValues) -> Value) {
        _seed = { environment in
            let seed1 = s1.seed(environment: environment)
            let seed2 = s2.seed(environment: environment)
            return Seed(objectWillChange: Publishers.MergeMany(seed1.objectWillChange,
                                                               seed2.objectWillChange)) {
                combined(seed1._value, seed2._value, environment)
            }
        }
    }

    public init<S1: SeedProtocol,
               S2: SeedProtocol,
               S3: SeedProtocol>(_ s1: S1,
                                 _ s2: S2,
                                 _ s3: S3,
                                 combined: @escaping (S1.T,
                                                      S2.T,
                                                      S3.T,
                                                      EnvironmentValues) -> Value) {
        _seed = { environment in
            let seed1 = s1.seed(environment: environment)
            let seed2 = s2.seed(environment: environment)
            let seed3 = s3.seed(environment: environment)

            return Seed(
                objectWillChange: Publishers.MergeMany(seed1.objectWillChange,
                                                       seed2.objectWillChange,
                                                       seed3.objectWillChange)) {
                combined(seed1._value, seed2._value, seed3._value, environment)
            }
        }
    }

    public init<S1: SeedProtocol,
               S2: SeedProtocol,
               S3: SeedProtocol,
               S4: SeedProtocol>(_ s1: S1,
                                 _ s2: S2,
                                 _ s3: S3,
                                 _ s4: S4,
                                 combined: @escaping (S1.T,
                                                      S2.T,
                                                      S3.T,
                                                      S4.T,
                                                      EnvironmentValues) -> Value) {
        _seed = { environment in
            let seed1 = s1.seed(environment: environment)
            let seed2 = s2.seed(environment: environment)
            let seed3 = s3.seed(environment: environment)
            let seed4 = s4.seed(environment: environment)

            return Seed(
                objectWillChange: Publishers.MergeMany(seed1.objectWillChange,
                                                       seed2.objectWillChange,
                                                       seed3.objectWillChange,
                                                       seed4.objectWillChange)) {
                combined(seed1._value, seed2._value, seed3._value, seed4._value, environment)
            }
        }
    }

    public func value(environment: EnvironmentValues) -> Value {
        fatalError()
    }

    public func seed(environment: EnvironmentValues) -> Seed<Value> { _seed(environment) }
}
