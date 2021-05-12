//
//  View+Route.swift
//  
//
//  Created by Ryoichi Izumita on 2021/05/13.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func route<R>(_ router: R) -> some View where R: Router {
        modifier(router)
    }
}
