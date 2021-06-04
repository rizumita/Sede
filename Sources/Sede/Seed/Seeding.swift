//
//  Created by Ryoichi Izumita on 2021/06/05.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct Seeding<Model, Msg>: DynamicProperty {
    private var wrapper: Wrapper

    public var wrappedValue: Wrapper { wrapper }

    public var model: Model {
        get { wrapper.value }
        nonmutating set { wrapper.value = newValue }
    }

    public init() {
        wrapper = Wrapper()
    }

    public init(_ value: Model) {
        wrapper = Wrapper(value: value)
    }

    @dynamicMemberLookup
    public class Wrapper {
        private var _value: Model?
        var value: Model {
            get {
                guard let value = _value else { fatalError("You should call initialize function before using seed") }
                return value
            }
            set {
                _value = newValue
            }
        }
        weak var seederWrapper: SeederWrapper<Model, Msg>?

        init(value: Model? = .none) {
            _value = value
        }

        public func initialize(_ value: Model) {
            _value = value
        }

        public subscript<U>(dynamicMember keyPath: KeyPath<Model, U>) -> U {
            value[keyPath: keyPath]
        }

        public func callAsFunction(_ msgs: Msg?...) {
            let cmd = Cmd<Msg>.batch(msgs.map(Cmd.ofMsgOptional))
            seederWrapper?.receive(cmd: cmd)
        }

        public func callAsFunction(_ cmd: Cmd<Msg>) {
            seederWrapper?.receive(cmd: cmd)
        }

        public func callAsFunction(@CmdBuilder<Msg> _ cmd: () -> Cmd<Msg>) {
            seederWrapper?.receive(cmd: cmd())
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Seeding.Wrapper {
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Model, Subject>) -> Subject {
        get {
            value[keyPath: keyPath]
        }
        set {
            value[keyPath: keyPath] = newValue
            seederWrapper?.model[keyPath: keyPath] = newValue
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Seeding.Wrapper where Model: ObservableValue {
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Model, Subject>) -> Subject {
        get {
            value[keyPath: keyPath]
        }
        set {
            seederWrapper?.keyPathWillChange(keyPath, in: Model.published)
            value[keyPath: keyPath] = newValue
        }
    }

}
