//
// Created by 和泉田 領一 on 2021/04/01.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol AnyObservableObject {
    var objectWillChange: AnyPublisher<(), Never> { get }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension AnyObservableObject {
    var objectWillChange: AnyPublisher<(), Never> { Empty<(), Never>(completeImmediately: false).eraseToAnyPublisher() }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Environment: AnyObservableObject where Value: ObservableObject {
    public var objectWillChange: AnyPublisher<(), Never> {
        self.wrappedValue.objectWillChange.map { _ in }.eraseToAnyPublisher()
    }
}
