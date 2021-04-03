//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Seedable {
    associatedtype Msg

    func seed(msg: Msg, environment: EnvironmentValues)
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Seedable {
    func genSeed(environment: EnvironmentValues) -> AnySeed<Msg> {
        AnySeed(seed: seed, environment: environment)
    }
}
