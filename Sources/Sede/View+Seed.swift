//
// Created by Ryoichi Izumita on 2021/03/15.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func sede<S>(_ seeder: S) -> some View where S: Seeder {
        modifier(seeder)
    }
}
