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
public class Seed<T>: UpdatableObject {
    @Published public var _value: T {
        willSet { _objectWillChange.send() }
    }
    public var objectWillChange: AnyPublisher<(), Never> {
        _objectWillChange.filter { [weak self] in self?.isSilent == false }
                         .subscribe(on: RunLoop.main)
                         .eraseToAnyPublisher()
    }

    private var getValue: () -> T
    private var isSilent = false
    private var isBaseUpdated = false
    private var _objectWillChange = PassthroughSubject<(), Never>()
    private var cancellables = Set<AnyCancellable>()

    public init(getValue: @escaping () -> T) {
        self._value = getValue()
        self.getValue = getValue
    }

    init<P: Publisher>(objectWillChange: P, getValue: @escaping () -> T) where P.Output == (), P.Failure == Never {
        self._value = getValue()
        self.getValue = getValue
        objectWillChange.subscribe(on: RunLoop.main)
                        .sink { [weak self] _ in
                            self?.isBaseUpdated = true
                            self?._objectWillChange.send()
                        }.store(in: &cancellables)
    }

    init<P: Publisher>(objectWillChange: P, getValue: @escaping () -> T) where P.Output == (), P.Failure == Never, T: ObservableObject {
        self._value = getValue()
        self.getValue = getValue
        objectWillChange.sink { [weak self] _ in
            self?.isBaseUpdated = true
            self?._objectWillChange.send()
        }.store(in: &cancellables)
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> U {
        _value[keyPath: keyPath]
    }

    public func update() {
        guard isBaseUpdated else { return }

        defer {
            isSilent = false
            isBaseUpdated = false
        }

        isSilent = true
        _value = getValue()
    }
}
