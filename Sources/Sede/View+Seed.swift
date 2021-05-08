//
// Created by 和泉田 領一 on 2021/03/15.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func sede<S>(_ seeder: S) -> some View where S: Seeder {
        modifier(seeder)
//        modifier(InjectModifier(seeder: seeder))
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private struct InjectModifier<S>: ViewModifier, DynamicProperty where S: Seeder {
    @ObservedObject var object: SeederWrapper<S.Model, S.Msg>
    var                 seeder: S

    init(seeder: S) {
        self.seeder = seeder
        object = SeederWrapper(seeder: seeder)
    }

    func body(content: Content) -> some View {
        content.environmentObject(object).modifier(seeder)
    }
}
