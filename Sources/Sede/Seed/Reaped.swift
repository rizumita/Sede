//
// Created by 和泉田 領一 on 2021/03/28.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
@dynamicMemberLookup
public struct Reaped<Value>: DynamicProperty {
    @EnvironmentObject var reap: AnyReap<Value>

    public var wrappedValue: Value {
        get { reap._value }
        nonmutating set { reap._value = newValue }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    public init() {}

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<Value, U>) -> U {
        get { wrappedValue[keyPath: keyPath] }
        set { wrappedValue[keyPath: keyPath] = newValue }
    }

    public subscript<U>(dynamicMember keyPath: KeyPath<Value, U>) -> U {
        wrappedValue[keyPath: keyPath]
    }

    public func update() {
        reap.update()
    }
}
