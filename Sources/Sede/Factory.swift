//
// Created by Ryoichi Izumita on 2021/03/08.
//

import SwiftUI

public protocol SimpleFactory {
    static func factory() -> Self
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol EnvironmentalFactory {
    static func factory(environment: EnvironmentValues) -> Self
}
