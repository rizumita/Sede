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
struct ReapModifier<Reap>: EnvironmentalModifier where Reap: ReapProtocol {
    struct Modifier: ViewModifier {
        var reap: Reap
        var anyReap: AnyReap<Reap.Value>

        func body(content: Content) -> some View {
            content.modifier(reap).environmentObject(anyReap)
        }
    }

    var reap: Reap

    func resolve(in environment: EnvironmentValues) -> some ViewModifier {
        Modifier(reap: reap, anyReap: reap.reap(environment: environment))
    }
}
