//
// Created by Ryoichi Izumita on 2021/02/27.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class Sow<Sede>: ObservableObject {
    private let sow: (Sede) -> ()

    init<S: _Sowing>(sowing: S) where S.Sede == Sede { sow = sowing.sow }

    public func callAsFunction(_ sede: Sede) {
        sow(sede)
    }
}
