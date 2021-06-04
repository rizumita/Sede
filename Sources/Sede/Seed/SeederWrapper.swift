//
//  SeederWrapper.swift
//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class SeederWrapper<Model, Msg>: ObservableObject {
    private var _initialize: (() -> ())?
    private var _getModel: () -> Model = { fatalError() }
    private var _setModel: (Model) -> () = { _ in }
    private var _update: () -> () = {}
    private var _receive: (Msg) -> () = { _ in }
    private var _objectWillChange: () -> AnyPublisher<(), Never> = { fatalError() }
    private var isUpdating = false
    private var cancellables = Set<AnyCancellable>()
    private var cmdCancellables = Set<AnyCancellable>()

    var model: Model {
        get {
            _initialize?()
            return _getModel()
        }
        set {
            _setModel(newValue)
        }
    }

    init<S>(seeder: S) where S: Seedable, S.Model == Model, S.Msg == Msg {
        _initialize = { [weak self] in
            guard let self = self else { return }

            seeder.seed.seederWrapper = self
            seeder.observedObjects.objectWillChange
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in self?.update() })
                .store(in: &self.cancellables)

            seeder.initialize()

            self._initialize = .none
        }

        update(seeder: seeder)
    }

    init(model: Model, receive: @escaping (Msg) -> () = { _ in }) {
        _getModel = { model }
        _receive = receive
    }

    func update<S>(seeder: S) where S: Seedable, S.Model == Model, S.Msg == Msg {
        _getModel = { seeder.seed.value }
        _setModel = { seeder.seed.value = $0 }
        _update = seeder.update
        _receive = seeder.receive(msg:)
        _objectWillChange = { seeder.observedObjects.objectWillChange.toVoidNever().eraseToAnyPublisher() }
    }

    func keyPathWillChange(_ keyPath: PartialKeyPath<Model>, in publishedKeyPaths: [PartialKeyPath<Model>]) {
        guard publishedKeyPaths.contains(keyPath) else { return }
        objectWillChange.send()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper {
    func update() {
        DispatchQueue.main.async { self._update() }
    }

    func receive(cmd: Cmd<Msg>) {
        if cmd.value.isEmpty {
            objectWillChange.send()
        } else {
            isUpdating = true
            cmd.dispatch({ [weak self] msg in self?.receive(msg: msg) }, cancellables: &cmdCancellables)
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
