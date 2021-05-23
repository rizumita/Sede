//
//  SeederWrapper.swift
//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class SeederWrapper<Model, Msg>: ObservableObject {
    private var _getModel: () -> Model
    private var _setModel: (Model) -> () = { _ in }
    private var _receive: (Msg) -> Cmd<Msg>
    private var isUpdating = false
    private var cancellables = Set<AnyCancellable>()

    var model: Model {
        get { _getModel() }
        set { _setModel(newValue) }
    }

    init<S>(seeder: S) where S: Seedable, S.Model == Model, S.Msg == Msg {
        _getModel = { seeder.seed }
        _setModel = { seeder.seed = $0 }
        _receive = seeder.receive(msg:)
        seeder.objectWillChange
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.receive(cmd: seeder.updateCmd)
            })
            .store(in: &cancellables)
        receive(cmd: seeder.initialize())
    }

    init(model: Model, receive: @escaping (Msg) -> Cmd<Msg> = { _ in .none }) {
        _getModel = { model }
        _receive = receive
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper {
    private func receive(cmd: Cmd<Msg>) {
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
                .dispatch({ [weak self] msg in self?.receive(msg: msg) }, cancellables: &self.cancellables)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper where Msg == Never {
    public func receive(msg: Msg) {}
}
