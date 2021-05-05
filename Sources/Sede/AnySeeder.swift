//
//  AnySeeder.swift
//
//  Created by 和泉田 領一 on 2021/05/02.
//

import Foundation
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class AnySeeder<Model, Msg>: ObservableObject {
    private var _initialize: () -> Diad<Model, Msg>
    private var _update:     (Model) -> Diad<Model, Msg>
    private var _receive:    (Model, Msg) -> ()
    private var isActivated  = false
    private var isUpdating   = false
    private var cancellables = Set<AnyCancellable>()

    lazy var model: Model = {
        let (newModel, cmd) = initialize()
        defer { cmd.dispatch { msg in self.receive(model: newModel, msg: msg) } }
        self.isActivated = true
        return newModel
    }()

    public let observedObjects: [AnyObservableObject]

    init<S>(seeder: S) where S: Seeder, S.Model == Model, S.Msg == Msg {
        _initialize = seeder.initialize
        _update = seeder.update(model:)
        _receive = seeder.receive(model:msg:)
        observedObjects = seeder.observedObjects
        anyObjectWillChange.receive(on: RunLoop.main)
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
        observedObjects = []
    }

    func updateCyclically() {
        guard isUpdating else { return }
        isUpdating = false

        if isActivated {
            let (newModel, cmd) = update(model: model)
            defer { cmd.dispatch { msg in self.receive(model: self.model, msg: msg) } }
            model = newModel
        } else {
            _ = model
        }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AnySeeder: Seeder {
    public func initialize() -> Diad<Model, Msg> {
        _initialize()
    }

    public func update(model: Model) -> Diad<Model, Msg> {
        _update(model)
    }

    public func receive(model: Model, msg: Msg) {
        DispatchQueue.main.async { [weak self] in
            self?._receive(model, msg)
        }
    }
}
