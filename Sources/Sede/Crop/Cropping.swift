//
// Created by Ryoichi Izumita on 2021/03/07.
//

import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol _Cropping {
    associatedtype Product = ProductPublisher.Output
    associatedtype Failure = ProductPublisher.Failure
    associatedtype ProductPublisher: Publisher where ProductPublisher.Output == Product, ProductPublisher.Failure == Failure

    var product: Product { get }
    var productPublisher: ProductPublisher { get }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension _Cropping where ProductPublisher == CurrentValueSubject<Product, Failure> {
    var product: Product { productPublisher.value }
}

public protocol Cropping: _Cropping, SimpleFactory {}

public protocol EnvironmentalCropping: _Cropping, EnvironmentalFactory {}
