//
//  Created by Ryoichi Izumita on 2021/05/27.
//

import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol ObservableValue {
    @PublishedBuilder static var published: [PartialKeyPath<Self>] { get }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@resultBuilder
public struct PublishedBuilder {
    public static func buildBlock<T>(_ components: PartialKeyPath<T>...) -> [PartialKeyPath<T>] {
        components
    }
}
