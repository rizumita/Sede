//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import SwiftUI
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
@dynamicMemberLookup
public struct Seeder<Model, Msg>: DynamicProperty {
    @EnvironmentObject private var seeder: SeederWrapper<Model, Msg>

    public var wrappedValue: Model {
        get { seeder.model }
        nonmutating set { seeder.model = newValue }
    }

    public var projectedValue: Binding<Model> {
        Binding(get: { seeder.model },
                set: { seeder.model = $0 })
    }

    public init() {}

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<Model, U>) -> U {
        get { wrappedValue[keyPath: keyPath] }
        set { wrappedValue[keyPath: keyPath] = newValue }
    }

    public subscript<U>(dynamicMember keyPath: KeyPath<Model, U>) -> U {
        wrappedValue[keyPath: keyPath]
    }

    public func callAsFunction(_ msg: Msg) {
        seeder.receive(msg: msg)
    }
}
