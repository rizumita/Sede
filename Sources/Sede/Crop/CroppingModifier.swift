//
// Created by Ryoichi Izumita on 2021/03/07.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
fileprivate struct CroppingModifier<C: Cropping>: ViewModifier {
    let factory: () -> C

    func body(content: Content) -> some View {
        content.environmentObject(Cropped(cropping: factory()))
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
fileprivate struct EnvironmentalCroppingModifier<C: EnvironmentalCropping>: EnvironmentalModifier {
    let factory: (EnvironmentValues) -> C

    func resolve(in environment: EnvironmentValues) -> some ViewModifier {
        Modifier(cropped: Cropped(cropping: factory(environment)))
    }

    private struct Modifier: ViewModifier {
        let cropped: Cropped<C.Product>

        func body(content: Content) -> some View {
            content.environmentObject(cropped)
        }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func cropping<C>(_ croppingType: C.Type) -> some View where C: Cropping {
        modifier(CroppingModifier(factory: C.factory))
    }

    func cropping<C>(_ croppingType: C.Type) -> some View where C: Cropping, C: Cacheable {
        modifier(CroppingModifier(factory: { getInstanceOf(C.self, C.factory) }))
    }

    func cropping<C>(_ croppingType: C.Type) -> some View where C: EnvironmentalCropping {
        modifier(EnvironmentalCroppingModifier(factory: C.factory(environment:)))
    }

    func cropping<C>(_ croppingType: C.Type) -> some View where C: EnvironmentalCropping, C: Cacheable {
        modifier(EnvironmentalCroppingModifier { environment in
            getInstanceOf(C.self) { C.factory(environment: environment) }
        })
    }
}
