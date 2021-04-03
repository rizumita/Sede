//
// Created by 和泉田 領一 on 2021/03/19.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct InjectModifier<Object: ObservableObject>: EnvironmentalModifier {
    struct Modifier: ViewModifier {
        var object: Object

        func body(content: Content) -> some View {
            content.environmentObject(object)
        }
    }

    let factory: (EnvironmentValues) -> Object

    func resolve(in environment: EnvironmentValues) -> some ViewModifier {
        Modifier(object: factory(environment))
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct ReapModifier<R>: ViewModifier where R: Reap {
    var reap: R

    func body(content: Content) -> some View {
        content.modifier(reap)
    }
}
