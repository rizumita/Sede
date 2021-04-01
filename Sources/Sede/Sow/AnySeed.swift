//
// Created by Ryoichi Izumita on 2021/02/27.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class AnySeed<Msg>: ObservableObject {
    private let reap: (Msg, EnvironmentValues) -> ()
    private let environment: EnvironmentValues

    public init(_ r: @escaping (Msg, EnvironmentValues) -> ()) {
        reap = r
        environment = EnvironmentValues()
    }

    init(seed: @escaping (Msg, EnvironmentValues) -> (), environment: EnvironmentValues) {
        self.reap = seed
        self.environment = environment
    }

    public func callAsFunction(_ msg: Msg) {
        reap(msg, environment)
    }

    public func update() {}
}
