//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import SwiftUI
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Seedable: ViewModifier, Hashable {
    associatedtype Model = ()
    associatedtype Msg = Never
    associatedtype ObservableObjectType: ObservableObject

    var seed: Seeding<Model, Msg>.Wrapper { get }

    @ObservedBuilder var observedObjects: ObservableObjectType { get }

    func initialize()

    func update()

    func receive(msg: Msg)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable {
    var observedObjects: some ObservableObject { ObservableObjectsContainer(objectWillChanges: []) }

    func initialize() {}

    func update() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: Self.self))
    }

    static func ==(lhs: Self, rhs: Self) -> Bool { true }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Model == () {
    func initialize() {}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Self: Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: Self.self))
        hasher.combine(id)
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Msg == Never {
    func receive(msg: Msg) {}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable {
    func body(content: Content) -> some View {
        let seederWrapper = seed.seederWrapper ?? SeederWrapper(seeder: self)
        seed.seederWrapper = seederWrapper
        return content.environmentObject(seederWrapper)
    }
}
