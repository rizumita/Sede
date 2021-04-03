//
// Created by 和泉田 領一 on 2021/04/01.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol AnyObservableObject {
    var observedObjects: [AnyObservableObject] { get }

    var anyObjectWillChange: AnyPublisher<(), Never> { get }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension AnyObservableObject {
    var observedObjects: [AnyObservableObject] { [] }

    var anyObjectWillChange: AnyPublisher<(), Never> {
        Publishers.MergeMany(observedObjects.map(\.anyObjectWillChange)).eraseToAnyPublisher()
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Environment: AnyObservableObject where Value: ObservableObject {
    public var anyObjectWillChange: AnyPublisher<(), Never> {
        self.wrappedValue.objectWillChange.map { _ in }.eraseToAnyPublisher()
    }
}
