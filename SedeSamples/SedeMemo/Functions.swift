//
// Created by Ryoichi Izumita on 2021/03/16.
//

import Foundation

precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}

infix operator •: CompositionPrecedence

public func •<A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    { (a: A) -> C in f(g(a)) }
}

precedencegroup LeftApplyPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

infix operator |>: LeftApplyPrecedence

@discardableResult
public func |><A, B>(a: A, f: (A) -> B) -> B {
    f(a)
}

public func tee<A>(_ f: @escaping (A) -> ()) -> (A) -> A {
    { a in
        f(a)
        return a
    }
}
