//
//  AnySeeder.swift
//
//  Created by 和泉田 領一 on 2021/05/02.
//

import Foundation
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class AnySeeder<Model, Msg>: ObservableObject {
    private var _initialize: () -> Model
    private var _update: (Model) -> Model
    private var _receive: (Msg) -> ()
    private var cancellables = Set<AnyCancellable>()
    private var isUpdating = false

    private (set) var model: Model?

    public let observedObjects: [AnyObservableObject]

    init<S>(seeder: S) where S: Seeder, S.Model == Model, S.Msg == Msg {
        _initialize = seeder.initialize
        _update = seeder.update(model:)
        _receive = seeder.receive(msg:)
        observedObjects = seeder.observedObjects
        anyObjectWillChange.receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self,
                      let model = self.model
                    else { return }
                self.set(model: self.update(model: model), needsPropagating: true)
            }
            .store(in: &cancellables)
    }

    /// For previewing
    public init(initialize: @escaping () -> Model, update: @escaping (Model) -> Model = { $0 }, receive: @escaping (Msg) -> ()) {
        _initialize = initialize
        _update = update
        _receive = receive
        observedObjects = []
    }

    func set(model: Model, needsPropagating: Bool) {
        if needsPropagating { objectWillChange.send() }
        self.model = model
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AnySeeder: Seeder {
    public func initialize() -> Model {
        _initialize()
    }

    public func update(model: Model) -> Model {
        _update(model)
    }

    public func receive(msg: Msg) {
        _receive(msg)
    }
}
