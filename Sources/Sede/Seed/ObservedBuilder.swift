//
//  Created by Ryoichi Izumita on 2021/05/22.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class ObservableObjectsContainer: ObservableObject {
    public var objectWillChange: AnyPublisher<(), Never>

    init(objectWillChanges: [AnyPublisher<(), Never>]) {
        objectWillChange = Publishers.MergeMany(objectWillChanges).eraseToAnyPublisher()
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@resultBuilder
public struct ObservedBuilder {
    public static func buildBlock<A: ObservableObject>(_ a: A) -> [AnyPublisher<(), Never>] {
        [a.objectWillChange.toVoidNever().eraseToAnyPublisher()]
    }

    public static func buildBlock<
                                 A: ObservableObject,
                                 B: ObservableObject
                                 >(_ a: A,
                                   _ b: B) -> [AnyPublisher<(), Never>] {
        [a.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         b.objectWillChange.toVoidNever().eraseToAnyPublisher()]
    }

    public static func buildBlock<
                                 A: ObservableObject,
                                 B: ObservableObject,
                                 C: ObservableObject
                                 >(_ a: A,
                                   _ b: B,
                                   _ c: C) -> [AnyPublisher<(), Never>] {
        [a.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         b.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         c.objectWillChange.toVoidNever().eraseToAnyPublisher()]
    }

    public static func buildBlock<
                                 A: ObservableObject,
                                 B: ObservableObject,
                                 C: ObservableObject,
                                 D: ObservableObject
                                 >(_ a: A,
                                   _ b: B,
                                   _ c: C,
                                   _ d: D) -> [AnyPublisher<(), Never>] {
        [a.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         b.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         c.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         d.objectWillChange.toVoidNever().eraseToAnyPublisher()]
    }

    public static func buildBlock<
                                 A: ObservableObject,
                                 B: ObservableObject,
                                 C: ObservableObject,
                                 D: ObservableObject,
                                 E: ObservableObject
                                 >(_ a: A,
                                   _ b: B,
                                   _ c: C,
                                   _ d: D,
                                   _ e: E) -> [AnyPublisher<(), Never>] {
        [a.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         b.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         c.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         d.objectWillChange.toVoidNever().eraseToAnyPublisher(),
         e.objectWillChange.toVoidNever().eraseToAnyPublisher()]
    }

    public static func buildIf<A: ObservableObject>(_ a: A?) -> AnyPublisher<(), Never> {
        if let a = a {
            return a.objectWillChange.toVoidNever().eraseToAnyPublisher()
        } else {
            return Empty<(), Never>().eraseToAnyPublisher()
        }
    }

    public static func buildEither<TruePublisher: ObservableObject>(first: TruePublisher) -> [AnyPublisher<(), Never>] {
        [first.objectWillChange.toVoidNever().eraseToAnyPublisher()]
    }

    public static func buildEither<FalsePublisher: ObservableObject>(second: FalsePublisher) -> [AnyPublisher<(), Never>] {
        [second.objectWillChange.toVoidNever().eraseToAnyPublisher()]
    }

    public static func buildFinalResult(_ component: [AnyPublisher<(), Never>]) -> ObservableObjectsContainer {
        ObservableObjectsContainer(objectWillChanges: component)
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension ObservedBuilder {

    /// Provides support for "if" statements with `#available()` clauses in
    /// multi-statement closures, producing conditional content for the "then"
    /// branch, i.e. the conditionally-available branch.
    public static func buildLimitedAvailability<A: ObservableObject>(_ a: A) -> [AnyPublisher<(), Never>] {
        [a.objectWillChange.toVoidNever().eraseToAnyPublisher()]
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    func toVoidNever() -> AnyPublisher<(), Never> {
        map { _ in }.catch { _ in Empty<(), Never>() }.eraseToAnyPublisher()
    }
}
