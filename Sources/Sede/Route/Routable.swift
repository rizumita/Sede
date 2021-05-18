//
//  Routable.swift
//
//  Created by Ryoichi Izumita on 2021/05/13.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Routable: ViewModifier {
    associatedtype RouteType
    associatedtype Location: View

    @ViewBuilder func locate(route: RouteType) -> Location
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Routable {
    public func body(content: Content) -> some View {
        content.environmentObject(RouterWrapper(router: self))
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Routable {
    public func base(_ route: RouteType) -> some View {
        RouterView(initialRoute: route).route(self)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private struct RouterView<R>: View {
    var initialRoute: R
    @Router<R> var router

    var body: some View {
        router(initialRoute)
    }
}
