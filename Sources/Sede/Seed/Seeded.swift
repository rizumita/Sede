//
//  Created by Ryoichi Izumita on 2021/05/02.
//

import SwiftUI
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct Seeded<Model, Msg>: DynamicProperty {
    @EnvironmentObject private var seederWrapper: SeederWrapper<Model, Msg>

    public var wrappedValue: WrappedValueWrapper {
        WrappedValueWrapper(seederWrapper: seederWrapper)
    }
    public var projectedValue: ProjectedValueWrapper {
        ProjectedValueWrapper(seederWrapper: seederWrapper)
    }

    public var model: Model {
        get { wrappedValue.seederWrapper.model }
        set { wrappedValue.seederWrapper.model = newValue }
    }

    public init() {}

    @dynamicMemberLookup
    public struct WrappedValueWrapper {
        var seederWrapper: SeederWrapper<Model, Msg>

        public subscript<U>(dynamicMember keyPath: KeyPath<Model, U>) -> U {
            seederWrapper.model[keyPath: keyPath]
        }

        public func send(_ msg: Msg) {
            seederWrapper.receive(msg: msg)
        }

        public func callAsFunction(_ msg: Msg) {
            seederWrapper.receive(msg: msg)
        }

        public func callAsFunction() -> Model {
            seederWrapper.model
        }
    }

    @dynamicMemberLookup
    public struct ProjectedValueWrapper {
        var seederWrapper: SeederWrapper<Model, Msg>
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Seeded.WrappedValueWrapper {
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Model, Subject>) -> Subject {
        get { seederWrapper.model[keyPath: keyPath] }
        nonmutating set {
            seederWrapper.model[keyPath: keyPath] = newValue
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Seeded.WrappedValueWrapper where Model: ObservableValue {
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Model, Subject>) -> Subject {
        get { seederWrapper.model[keyPath: keyPath] }
        nonmutating set {
            seederWrapper.keyPathWillChange(keyPath, in: Model.published)
            seederWrapper.model[keyPath: keyPath] = newValue
        }
    }

}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Seeded.ProjectedValueWrapper {
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Model, Subject>) -> Binding<Subject> {
        Binding(get: { seederWrapper.model[keyPath: keyPath] },
                set: {
                    var model = seederWrapper.model
                    model[keyPath: keyPath] = $0
                    seederWrapper.model = model
                })
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Seeded.ProjectedValueWrapper where Model: ObservableValue {
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Model, Subject>) -> Binding<Subject> {
        Binding(get: { seederWrapper.model[keyPath: keyPath] },
                set: {
                    seederWrapper.keyPathWillChange(keyPath, in: Model.published)
                    var model = seederWrapper.model
                    model[keyPath: keyPath] = $0
                    seederWrapper.model = model
                })
    }
}
