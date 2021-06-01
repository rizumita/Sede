//
// Created by Ryoichi Izumita on 2021/03/15.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func seed<S>(_ seeder: S) -> some View where S: Seedable {
        modifier(seeder).environmentObject(getWrapper(seeder: seeder))
    }

    func seed<Model, Msg>(model: Model, receive: @escaping (Msg) -> () = { _ in }) -> some View {
        environmentObject(SeederWrapper(model: model, receive: receive))
    }

    func seed<Model>(model: Model) -> some View {
        environmentObject(SeederWrapper<Model, Never>(model: model, receive: { _ in }))
    }
}
