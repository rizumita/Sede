//
// Created by 和泉田 領一 on 2021/03/20.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CombinedReap<Value>: ReapProtocol {
    private var _initialize: (EnvironmentValues) -> Value
    private var _update: (Value, EnvironmentValues) -> Value
    public var observedObjects: [AnyObservableObject]

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
        var value1: S1.Value!
        var value2: S2.Value!

        _initialize = { environment in
            value1 = s1.initialize(environment: environment)
            value2 = s2.initialize(environment: environment)
            return initialize(value1, value2, environment)
        }
        _update = { value, environment in
            value1 = s1.update(value: value1, environment: environment)
            value2 = s2.update(value: value2, environment: environment)
            return update(value, value1, value2, environment)
        }
        observedObjects = [s1, s2]
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
        var value1: S1.Value!
        var value2: S2.Value!
        var value3: S3.Value!

        _initialize = { environment in
            value1 = s1.initialize(environment: environment)
            value2 = s2.initialize(environment: environment)
            value3 = s3.initialize(environment: environment)
            return initialize(value1, value2, value3, environment)
        }
        _update = { value, environment in
            value1 = s1.update(value: value1, environment: environment)
            value2 = s2.update(value: value2, environment: environment)
            value3 = s3.update(value: value3, environment: environment)
            return update(value, value1, value2, value3, environment)
        }
        observedObjects = [s1, s2, s3]
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
        var value1: S1.Value!
        var value2: S2.Value!
        var value3: S3.Value!
        var value4: S4 .Value!

        _initialize = { environment in
            value1 = s1.initialize(environment: environment)
            value2 = s2.initialize(environment: environment)
            value3 = s3.initialize(environment: environment)
            value4 = s4.initialize(environment: environment)
            return initialize(value1, value2, value3, value4, environment)
        }
        _update = { value, environment in
            value1 = s1.update(value: value1, environment: environment)
            value2 = s2.update(value: value2, environment: environment)
            value3 = s3.update(value: value3, environment: environment)
            value4 = s4.update(value: value4, environment: environment)
            return update(value, value1, value2, value3, value4, environment)
        }
        observedObjects = [s1, s2]
    }

    public func initialize(environment: EnvironmentValues) -> Value {
        _initialize(environment)
    }

    public func update(value: Value, environment: EnvironmentValues) -> Value {
        _update(value, environment)
    }
}
