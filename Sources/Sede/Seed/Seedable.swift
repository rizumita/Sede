//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import SwiftUI
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Seedable: ViewModifier, Hashable {
    associatedtype Model
    associatedtype Msg = Never
    associatedtype Observed: Publisher

    var seed: Model { get nonmutating set }

    @ObservedBuilder var objectWillChange: Observed { get }

    func initialize() -> Cmd<Msg>

    func update()

    func receive(msg: Msg)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable {
    var objectWillChange: some Publisher { Empty<Model, Never>() }

    func initialize() -> Cmd<Msg> { .none }

    func update() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: Self.self))
    }

    static func ==(lhs: Self, rhs: Self) -> Bool { true }
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
    func receive(msg: Msg) {}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Seedable {
    func body(content: Content) -> some View {
        content.environmentObject(getWrappers(seeder: self))
    }
}

private final class WeakRef {
    weak var value: AnyObject?
}

private var cachedWrappers = [AnyHashable : WeakRef]()

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private func getWrappers<S>(seeder: S) -> SeederWrapper<S.Model, S.Msg> where S: Seedable {
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
