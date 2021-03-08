//
// Created by Ryoichi Izumita on 2021/03/07.
//

import Foundation
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class Cropped<Product>: ObservableObject {
    @Published public var product: Product
    @Published public var error: Error?

    private var cancellables = Set<AnyCancellable>()

    init<C: _Cropping>(cropping: C) where C.ProductPublisher.Output == Product {
        product = cropping.product

        cropping.productPublisher.sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.error = error
            }
        }, receiveValue: { [weak self] product in
            self?.product = product
        }).store(in: &cancellables)
    }
}
