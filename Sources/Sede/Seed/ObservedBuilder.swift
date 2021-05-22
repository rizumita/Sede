//
//  Created by Ryoichi Izumita on 2021/05/22.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@resultBuilder
public struct ObservedBuilder {
    public static func buildBlock<A: Publisher>(_ a: A) -> some Publisher where A.Failure == Never {
        a.toVoidNever()
    }

    public static func buildBlock<
                                 A: Publisher,
                                 B: Publisher
                                 >(_ a: A,
                                   _ b: B) -> some Publisher {
        Publishers.MergeMany(a.toVoidNever(),
                             b.toVoidNever())
    }

    public static func buildBlock<
                                 A: Publisher,
                                 B: Publisher,
                                 C: Publisher
                                 >(_ a: A,
                                   _ b: B,
                                   _ c: C) -> some Publisher {
        Publishers.MergeMany(a.toVoidNever(),
                             b.toVoidNever(),
                             c.toVoidNever())
    }

    public static func buildBlock<
                                 A: Publisher,
                                 B: Publisher,
                                 C: Publisher,
                                 D: Publisher
                                 >(_ a: A,
                                   _ b: B,
                                   _ c: C,
                                   _ d: D) -> some Publisher {
        Publishers.MergeMany(a.toVoidNever(),
                             b.toVoidNever(),
                             c.toVoidNever(),
                             d.toVoidNever())
    }

    public static func buildBlock<
                                 A: Publisher,
                                 B: Publisher,
                                 C: Publisher,
                                 D: Publisher,
                                 E: Publisher
                                 >(_ a: A,
                                   _ b: B,
                                   _ c: C,
                                   _ d: D,
                                   _ e: E) -> some Publisher {
        Publishers.MergeMany(a.toVoidNever(),
                             b.toVoidNever(),
                             c.toVoidNever(),
                             d.toVoidNever(),
                             e.toVoidNever())
    }

    public static func buildIf<A: Publisher>(_ a: A?) -> AnyPublisher<(), Never> {
        if let a = a {
            return a.toVoidNever()
        } else {
            return Empty<(), Never>().eraseToAnyPublisher()
        }
    }

    public static func buildEither<TruePublisher: Publisher, FalsePublisher: Publisher>(first: TruePublisher) -> some Publisher {
        first.toVoidNever()
    }

    public static func buildEither<TruePublisher: Publisher, FalsePublisher: Publisher>(second: FalsePublisher) -> some Publisher {
        second.toVoidNever()
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension ObservedBuilder {

    /// Provides support for "if" statements with `#available()` clauses in
    /// multi-statement closures, producing conditional content for the "then"
    /// branch, i.e. the conditionally-available branch.
    public static func buildLimitedAvailability<A: Publisher>(_ a: A) -> some Publisher {
        a.toVoidNever()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publisher {
    func toVoidNever() -> AnyPublisher<(), Never> {
        map { _ in }.catch { _ in Empty<(), Never>() }.eraseToAnyPublisher()
    }
}
