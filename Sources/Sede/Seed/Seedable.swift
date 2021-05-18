//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Seedable: ViewModifier, AnyObservableObject {
    associatedtype Model
    associatedtype Msg

    func initialize() -> (Model, Cmd<Msg>)

    func update(model: Model) -> (Model, Cmd<Msg>)

    func receive(model: Model, msg: Msg)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable {
    func update(model: Model) -> (Model, Cmd<Msg>) {
        (initialize().0, .none)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Model == () {
    func initialize() -> (Model, Cmd<Msg>) { ((), .none) }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Msg == Never {
    func receive(model: Model, msg: Msg) {}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable {
    func body(content: Content) -> some View {
        content.environmentObject(SeederWrapper(seeder: self))
    }
}
