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
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in self?.objectWillChange.send() })
            .store(in: &cancellables)
        seeder.initialize().dispatch({ [weak self] msg in self?.receive(msg: msg) }, cancellables: &cancellables)
    }

    init(model: Model, receive: @escaping (Msg) -> Cmd<Msg> = { _ in .none }) {
        _getModel = { model }
        _receive = receive
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper {
    func receive(msg: Msg) {
        DispatchQueue.main.async {
            self._receive(msg).dispatch({ [weak self] msg in self?.receive(msg: msg) }, cancellables: &self.cancellables)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SeederWrapper where Msg == Never {
    public func receive(msg: Msg) {}
}
