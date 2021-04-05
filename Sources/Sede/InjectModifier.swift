//
// Created by 和泉田 領一 on 2021/03/19.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct InjectModifier<Modifier>: ViewModifier where Modifier: ViewModifier {
    var object: Modifier

    func body(content: Content) -> some View { content.modifier(object) }
}
