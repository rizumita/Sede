//
//  Created by Ryoichi Izumita on 2021/05/22.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct VariableSeeder<Model>: Seedable, Identifiable where Model: Identifiable {
    @Seeding<Model, Never> public var seed

    public init(_ model: Model) {
        seed.initialize(model)
    }

    public var id: Model.ID { seed.id }
}
