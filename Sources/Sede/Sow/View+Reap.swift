//
// Created by Ryoichi Izumita on 2021/03/01.
//

import SwiftUI

@available(OSX 10.15, iOS 14.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func reap<R: ReapProtocol>(_ r: R) -> some View {
        modifier(InjectModifier(factory: r.genReap(environment:)))
    }
}
