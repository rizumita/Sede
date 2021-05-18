//
//  Created by Ryoichi Izumita on 2021/05/13.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct Router<R>: DynamicProperty {
    @EnvironmentObject private var router: RouterWrapper<R>

    public var wrappedValue: (R) -> AnyView {
        router.locate(route:)
    }

    public init() {}
}
