//
// Created by Ryoichi Izumita on 2021/03/01.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
fileprivate struct SowingModifier<S: Sowing>: ViewModifier {
    let factory: () -> S

    func body(content: Content) -> some View {
        content.environmentObject(Sow(sowing: factory()))
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
fileprivate struct EnvironmentalSowingModifier<S: EnvironmentalSowing>: EnvironmentalModifier {
    let factory: (EnvironmentValues) -> S

    func resolve(in environment: EnvironmentValues) -> some ViewModifier {
        Modifier(sow: Sow(sowing: factory(environment)))
    }

    private struct Modifier: ViewModifier {
        let sow: Sow<S.Sede>

        func body(content: Content) -> some View {
            content.environmentObject(sow)
        }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func sowing<S>(_ sowingType: S.Type) -> some View where S: Sowing {
        self.modifier(SowingModifier(factory: S.factory))
    }

    func sowing<S>(_ sowingType: S.Type) -> some View where S: Sowing, S: Cacheable {
        self.modifier(SowingModifier { getInstanceOf(S.self, S.factory) })
    }

    func sowing<S>(_ sowingType: S.Type) -> some View where S: EnvironmentalSowing {
        self.modifier(EnvironmentalSowingModifier(factory: S.factory(environment:)))
    }

    func sowing<S>(_ sowingType: S.Type) -> some View where S: EnvironmentalSowing, S: Cacheable {
        self.modifier(EnvironmentalSowingModifier { environment in
            getInstanceOf(S.self) { S.factory(environment: environment) }
        })
    }
}
