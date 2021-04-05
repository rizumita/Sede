//
// Created by 和泉田 領一 on 2021/03/15.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func reap<S: Reapable>(_ reap: S) -> some View {
        modifier(InjectModifier(object: reap))
    }
}
