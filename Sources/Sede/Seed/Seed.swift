//
//  Seed.swift
//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
@dynamicMemberLookup
public struct Seed<Model, Msg> {
    @EnvironmentObject private var seeder: SeederWrapper<Model, Msg>

    public var wrappedValue: Model {
        get { seeder.model }
        nonmutating set { seeder.set(model: newValue) }
    }

    public var projectedValue: Binding<Model> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
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
        seeder.receive(model: wrappedValue, msg: msg)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Seed: DynamicProperty {
    public func update() {
        seeder.updateCyclically()
    }
}
