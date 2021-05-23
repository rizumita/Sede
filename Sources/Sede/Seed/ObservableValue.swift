//
//  Created by Ryoichi Izumita on 2021/05/23.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol ObservableValue {
    associatedtype ChangePublisher: Publisher

    @ObservedBuilder var objectWillChange: ChangePublisher { get }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ObservableValue {
    var objectWillChange: Empty<(), Never> { Empty<(), Never>() }
}
