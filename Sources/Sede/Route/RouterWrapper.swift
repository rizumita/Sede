//
//  RouterWrapper.swift
//  
//
//  Created by Ryoichi Izumita on 2021/05/13.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class RouterWrapper<Route>: ObservableObject {
    private let _locate: (Route) -> AnyView

    init<R>(router: R) where R: Router, Route == R.Route {
        _locate = { AnyView(router.locate(route: $0)) }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension RouterWrapper  {
    public func locate(route: Route) -> AnyView {
        _locate(route)
    }
}
