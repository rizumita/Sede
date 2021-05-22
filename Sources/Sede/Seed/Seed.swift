//
//  Created by Ryoichi Izumita on 2021/05/22.
//

import Foundation
import Combine
import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
@dynamicMemberLookup
public class Seed<Value> {
    public var wrappedValue: Value

    public var projectedValue: Binding<Value> {
        Binding(
            get: { [self] in wrappedValue },
            set: { [self] in wrappedValue = $0 }
        )
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<Value, U>) -> U {
        get { wrappedValue[keyPath: keyPath] }
        set { wrappedValue[keyPath: keyPath] = newValue }
    }

    public subscript<U>(dynamicMember keyPath: KeyPath<Value, U>) -> U {
        wrappedValue[keyPath: keyPath]
    }
}
