//
// Created by 和泉田 領一 on 2021/03/21.
//

import Foundation
import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol UpdatableObject: ObservableObject {
    func update()
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
struct UpdatableContainer<T: UpdatableObject>: DynamicProperty {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    func update() {
        wrappedValue.update()
    }
}
