//
// Created by Ryoichi Izumita on 2021/03/01.
//

import SwiftUI

@available(OSX 10.15, iOS 14.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func seed<S>(_ seed: S) -> some View where S: Seedable {
        modifier(InjectModifier(object: seed))
    }
}
