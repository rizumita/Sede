//
//  Seeder.swift
//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias Diad<Model, Msg> = (Model, Cmd<Msg>)

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Seeder: ViewModifier, AnyObservableObject {
    associatedtype Model
    associatedtype Msg

    func initialize() -> Diad<Model, Msg>

    func update(model: Model) -> Diad<Model, Msg>

    func receive(model: Model, msg: Msg)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seeder {
    func update(model: Model) -> Diad<Model, Msg> {
        (initialize().0, .none)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seeder where Model == Never {
    func initialize() -> Diad<Model, Msg> { fatalError() }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seeder where Msg == Never {
    func receive(model: Model, msg: Msg) {}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seeder {
    func body(content: Content) -> some View {
        content.environmentObject(SeederWrapper(seeder: self))
    }
}
