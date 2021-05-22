//
// Created by Ryoichi Izumita on 2021/03/15.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func seed<S>(_ seeder: S) -> some View where S: Seedable {
        modifier(seeder)
    }

    func seed<Model, Msg>(model: @autoclosure @escaping () -> Model,
                          receive: @escaping (Msg) -> ()) -> some View {
        environmentObject(SeederWrapper(model: model, receive: receive))
    }
}
