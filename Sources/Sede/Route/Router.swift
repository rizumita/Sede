//
//  Route.swift
//
//  Created by Ryoichi Izumita on 2021/05/13.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Router: ViewModifier {
    associatedtype Route
    associatedtype Location: View

    @ViewBuilder func locate(route: Route) -> Location
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Router {
    public func body(content: Content) -> some View {
        content.environmentObject(RouterWrapper(router: self))
    }
}
