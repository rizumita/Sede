//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Reap: ViewModifier, AnyObservableObject {
    associatedtype Value

    func initialize() -> Value

    func update(value: Value) -> Value
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Reap {
    func update(value: Value) -> Value { value }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Reap {
    func body(content: Content) -> some View { content.environmentObject(AnyReap(self)) }
}
