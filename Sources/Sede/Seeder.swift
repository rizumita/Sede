//
//  Seeder.swift
//
//  Created by 和泉田 領一 on 2021/05/02.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Seeder: ViewModifier, AnyObservableObject {
    associatedtype Model
    associatedtype Msg

    func initialize() -> Model

    func update(model: Model) -> Model

    func receive(msg: Msg)
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seeder {
    func update(model: Model) -> Model {
        initialize()
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seeder {
    func body(content: Content) -> some View {
        content.environmentObject(AnySeeder(seeder: self))
    }
}
