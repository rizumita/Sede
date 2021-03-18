//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation
import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol ReapProtocol {
    associatedtype Msg

    func reap(msg: Msg, environment: EnvironmentValues)
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ReapProtocol {
    func genReap(environment: EnvironmentValues) -> Reap<Msg> {
        Reap(reap: reap, environment: environment)
    }
}
