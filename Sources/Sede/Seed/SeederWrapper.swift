//
//  SeederWrapper.swift
//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class SeederWrapper<Model, Msg>: ObservableObject {
    private let _update: (Model) -> (Model, Cmd<Msg>)
    private let _receive: (Model, Msg) -> ()
    private var isUpdating = true
    private var cancellables = Set<AnyCancellable>()

    var model: Model {
        didSet { objectWillChange.send() }
    }

    init<S>(seeder: S) where S: Seedable, S.Model == Model, S.Msg == Msg {
        let (newModel, cmd) = seeder.initialize()
        defer { cmd.dispatch { msg in self.receive(model: newModel, msg: msg) } }
        model = newModel

        _update = seeder.update(model:)
        _receive = seeder.receive(model:msg:)

        Publishers.MergeMany(seeder.observedObjects.map(\.anyObjectWillChange)).receive(on: RunLoop.main)
                  .sink { [weak self] in
                      self?.isUpdating = true
                      self?.objectWillChange.send()
                  }
                  .store(in: &cancellables)
    }

    init(initialize: @escaping () -> Model,
                receive: @escaping (Model, Msg) -> ()) {
        model = initialize()
        _update = { ($0, .none) }
        _receive = receive
    }

    func updateCyclically() {
        guard isUpdating else { return }
        isUpdating = false

        update()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper {
    public func update() {
        guard Model.self != Never.self else { return }
        let (newModel, cmd) = _update(model)
        defer { cmd.dispatch { msg in self.receive(model: self.model, msg: msg) } }
        model = newModel
    }

    public func receive(model: Model, msg: Msg) {
        DispatchQueue.main.async { [weak self] in
            self?._receive(model, msg)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper where Msg == Never {
    public func receive(model: Model, msg: Msg) {}
}
