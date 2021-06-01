//
//  SeederWrapper.swift
//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class SeederWrapper<Model, Msg>: ObservableObject {
    private var _initialize: () -> Model = { fatalError() }
    private var _receive: (Msg) -> () = { _ in }
    private var _objectWillChange: () -> AnyPublisher<(), Never> = { fatalError() }
    private var _update: Cmd<Msg> = .none
    private var isUpdating = false
    private var cancellables = Set<AnyCancellable>()

    private var _model: Model?
    var model: Model {
        get {
            if let _model = _model {
                return _model
            } else {
                cancellables = .init()
                _objectWillChange()
                    .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                        guard let self = self else { return }
                        self.receive(cmd: self._update)
                    })
                    .store(in: &cancellables)

                let model = _initialize()
                _model = model
                return model
            }
        }
        set { _model = newValue }
    }

    init<S>(seeder: S) where S: Seedable, S.Model == Model, S.Msg == Msg {
        update(seeder: seeder)
    }

    init(model: Model, receive: @escaping (Msg) -> () = { _ in }) {
        self._initialize = { model }
        _receive = receive
    }

    func update<S>(seeder: S) where S: Seedable, S.Model == Model, S.Msg == Msg {
        _initialize = seeder.initialize
        _receive = seeder.receive(msg:)
        _objectWillChange = { seeder.observedObjects.objectWillChange.toVoidNever().eraseToAnyPublisher() }
        _update = seeder.update
    }

    func keyPathWillChange(_ keyPath: PartialKeyPath<Model>, in publishedKeyPaths: [PartialKeyPath<Model>]) {
        guard publishedKeyPaths.contains(keyPath) else { return }
        objectWillChange.send()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper {
    func receive(cmd: Cmd<Msg>) {
        if cmd.value.isEmpty {
            objectWillChange.send()
        } else {
            isUpdating = true
            cmd.dispatch({ [weak self] msg in self?.receive(msg: msg) }, cancellables: &self.cancellables)
        }
    }

    func receive(msg: Msg) {
        DispatchQueue.main.async {
            if self.isUpdating {
                self.isUpdating = false
                self.objectWillChange.send()
            }
            self._receive(msg)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper where Msg == Never {
    public func receive(msg: Msg) {}
}
