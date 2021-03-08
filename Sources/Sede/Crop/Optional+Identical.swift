//
// Created by Ryoichi Izumita on 2021/03/07.
//

import Foundation

extension Optional: Identical {
    public static func identity() -> Self { .none }

    public static func identity() -> Self where Wrapped: Identical { Wrapped.identity() }
}
