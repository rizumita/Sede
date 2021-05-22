//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import SwiftUI
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Seedable: ViewModifier, ObservableValue, Hashable {
    associatedtype Model = ()
    associatedtype Msg = Never

    var seed: Model { get nonmutating set }

    func initialize() -> Cmd<Msg>

    func receive(msg: Msg) -> Cmd<Msg>
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable {
    func initialize() -> Cmd<Msg> { .none }

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: Self.self))
    }

    static func ==(lhs: Self, rhs: Self) -> Bool { true }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Model == () {
    var seed: Model {
        get {}
        nonmutating set {}
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Model: Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(seed.id)
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.seed.id == rhs.seed.id
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Model: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.seed == rhs.seed
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Model: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(seed)
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.seed.hashValue == rhs.seed.hashValue
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable where Msg == Never {
    func receive(msg: Msg) -> Cmd<Msg> { .none }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ObservableValue where Self: Seedable, Self.Model: ObservableObject {
    var objectWillChange: Self.Model.ObjectWillChangePublisher { seed.objectWillChange }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable {
    func body(content: Content) -> some View {
        content.environmentObject(getWrapper(seeder: self))
    }
}

private final class WeakRef {
    weak var value: AnyObject?
}

private var cachedWrappers = [AnyHashable : WeakRef]()

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private func getWrapper<S>(seeder: S) -> SeederWrapper<S.Model, S.Msg> where S: Seedable {
    let cachedInstance = cachedWrappers[seeder]?.value
    if let cachedInstance = cachedInstance as? SeederWrapper<S.Model, S.Msg> {
        return cachedInstance
    } else {
        let newInstance = SeederWrapper(seeder: seeder)
        let ref = WeakRef()
        ref.value = newInstance
        cachedWrappers[seeder] = ref
        return newInstance
    }
}
