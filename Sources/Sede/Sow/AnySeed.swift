//
// Created by Ryoichi Izumita on 2021/02/27.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class AnySeed<Msg>: Seedable, ObservableObject {
    private let _seed: (Msg) -> ()

    public init(_ seed: @escaping (Msg) -> ()) {
        _seed = seed
    }

    init<S>(_ s: S) where S: Seedable, S.Msg == Msg {
        _seed = s.seed(msg:)
    }

    public func seed(msg: Msg) { _seed(msg) }
}
