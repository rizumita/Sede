//
//  SedeProtocol.swift
//  Sede
//
//  Created by Ryoichi Izumita on 2021/03/10.
//

import Foundation
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@dynamicMemberLookup
public class Seed<T>: ObservableObject {
    public lazy var _value: T = getValue()
    public var objectWillChange: Publishers.Share<PassthroughSubject<(), Never>> { _objectWillChange.share() }

    private var getValue: () -> T
    private let _objectWillChange = PassthroughSubject<(), Never>()
    private var cancellables = Set<AnyCancellable>()

    public init(getValue: @escaping () -> T) {
        self.getValue = getValue
    }

    init<P: Publisher>(objectWillChange: P, getValue: @escaping () -> T) where P.Output == (), P.Failure == Never {
        self.getValue = getValue
        objectWillChange.subscribe(_objectWillChange).store(in: &cancellables)
        self.objectWillChange.sink { [weak self] in self?.update() }.store(in: &cancellables)
    }

    init<P: Publisher>(objectWillChange: P, getValue: @escaping () -> T) where P.Output == (), P.Failure == Never, T: ObservableObject {
        self.getValue = getValue
        self.getValue = { [weak self] in
            let value = getValue()

            guard let self = self else { return value }

            self.cancellables.forEach { $0.cancel() }

            value.objectWillChange.map { _ in }.subscribe(self._objectWillChange).store(in: &self.cancellables)
            objectWillChange.subscribe(self._objectWillChange).store(in: &self.cancellables)
            self.objectWillChange.sink { [weak self] in self?.update() }.store(in: &self.cancellables)

            return value
        }
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> U {
        _value[keyPath: keyPath]
    }

    func update() {
        _value = getValue()
    }
}
