//
//  Created by Ryoichi Izumita on 2021/05/22.
//

import Foundation
import Combine
import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct Seed<Value> {
    public var wrappedValue: WrappedValueWrapper = WrappedValueWrapper<Value>(value: .none)

    public var value: Value {
        get {
            guard let value = wrappedValue.value else { fatalError() }
            return value
        }
        set { wrappedValue.value = newValue }
    }

    public init() {}

    public init(_ value: Value) {
        wrappedValue = WrappedValueWrapper(value: value)
    }

    @dynamicMemberLookup
    public class WrappedValueWrapper<Value> {
        var value: Value!
        var keyPathWillChange: (PartialKeyPath<Value>) -> () = { _ in }

        public init(value: Value!) { self.value = value }

        public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Subject {
            get {
                value[keyPath: keyPath]
            }
            set {
//                seederWrapper.keyPathWillChange(keyPath)
                value[keyPath: keyPath] = newValue
            }
        }

        public subscript<U>(dynamicMember keyPath: KeyPath<Value, U>) -> U {
            value[keyPath: keyPath]
        }
    }
}
