//
// Created by 和泉田 領一 on 2021/03/19.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct InjectModifier<Object: UpdatableObject>: EnvironmentalModifier {
    struct Modifier: ViewModifier {
        var object: Object

        func body(content: Content) -> some View {
            InjectView(child: content, object: object)
        }

        private struct InjectView<V: View>: View {
            let child: V
            @UpdatableContainer var object: Object
            @ObservedObject var observedObject: Object

            init(child: V, object: Object) {
                self.child = child
                self.object = object
                self.observedObject = object
            }

            var body: some View {
                child.environmentObject(object)
            }
        }
    }

    let factory: (EnvironmentValues) -> Object

    func resolve(in environment: EnvironmentValues) -> some ViewModifier {
        Modifier(object: factory(environment))
    }
}
