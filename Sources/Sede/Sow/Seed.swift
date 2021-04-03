//
// Created by 和泉田 領一 on 2021/03/28.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct Seed<Msg>: DynamicProperty {
    @EnvironmentObject var seed: AnySeed<Msg>

    public var wrappedValue: (Msg) -> () { seed.callAsFunction }

    public init() {}
}
