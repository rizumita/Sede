//
//  SeederWrapper.swift
//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class SeederWrapper<Model, Msg>: ObservableObject {
    private let _initialize: () -> Diad<Model, Msg>
    private let _update:     (Model) -> Diad<Model, Msg>
    private let _receive:    (Model, Msg) -> ()
    private var isUpdating   = false
    private var cancellables = Set<AnyCancellable>()

    private var _model: Model?
    var model: Model {
            if let model = _model {
                return model
            } else {
                initialize()
                return _model!
            }
    }

    init<S>(seeder: S) where S: Seeder, S.Model == Model, S.Msg == Msg {
        _initialize = seeder.initialize
        _update = seeder.update(model:)
        _receive = seeder.receive(model:msg:)
        Publishers.MergeMany(seeder.observedObjects.map(\.anyObjectWillChange)).receive(on: RunLoop.main)
                  .sink { [weak self] in
                      self?.isUpdating = true
                      self?.objectWillChange.send()
                  }
                  .store(in: &cancellables)
    }

    /// For previewing
    public init(initialize: @escaping () -> Model,
                receive: @escaping (Model, Msg) -> ()) {
        _initialize = { (initialize(), .none) }
        _update = { ($0, .none) }
        _receive = receive
    }

    func updateCyclically() {
        guard isUpdating else { return }
        isUpdating = false

        update(model: model)
    }

    func set(model: Model) {
        _model = model
        objectWillChange.send()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper {
    public func initialize() {
        let (newModel, cmd) = _initialize()
        defer { cmd.dispatch { msg in self.receive(model: newModel, msg: msg) } }
        _model = newModel
    }

    public func update(model: Model) {
        let (newModel, cmd) = _update(model)
        defer { cmd.dispatch { msg in self.receive(model: self.model, msg: msg) } }
        _model = newModel
    }

    public func receive(model: Model, msg: Msg) {
        DispatchQueue.main.async { [weak self] in
            self?._receive(model, msg)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper where Model == Never {
    public func initialize() {}

    func updateCyclically() {}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper where Msg == Never {
    public func receive(model: Model, msg: Msg) {}
}
