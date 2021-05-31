//
//  Created by Ryoichi Izumita on 2021/05/22.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct VariableSeeder<Model>: Seedable, Identifiable where Model: Identifiable {
    @Seeded<Model, Never> public var seed
    private var model: Model

    public func initialize() -> (Model, Cmd<Never>) {
        (model, .none)
    }

    public init(seed: Model) {
        self.model = seed
    }

    public var id: Model.ID { model.id }
}
