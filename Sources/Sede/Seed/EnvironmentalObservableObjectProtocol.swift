//
// Created by 和泉田 領一 on 2021/03/28.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol EnvironmentalObservableObjectProtocol {
    func observable(environment: EnvironmentValues) -> AnyPublisher<(), Never>
}
