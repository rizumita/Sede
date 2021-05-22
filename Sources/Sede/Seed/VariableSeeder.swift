//
//  Created by Ryoichi Izumita on 2021/05/22.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct VariableSeeder<Model>: Seedable {
    @Seed public var seed: Model

    public init(seed: Model) { self.seed = seed }
}
