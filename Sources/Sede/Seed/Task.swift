//
//  Created by Ryoichi Izumita on 2021/05/23.
//

import Foundation
import Combine

@available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct Task<Value, ErrorType: Swift.Error> {

    public typealias Observer = (Result<Value, ErrorType>) -> Void
    public typealias Work = (@escaping Observer, inout Set<AnyCancellable>) -> Void

    let work: Work

    public init(observe: @escaping (@escaping Observer) -> ()) {
        work = { fulfill, _ in
            observe(fulfill)
        }
    }

    public init(work: @escaping Work) {
        self.work = work
    }

    public init<P: Publisher>(_ publisher: P) where P.Output == Value, P.Failure == ErrorType {
        work = { fulfill, cancellables in
            publisher.sink(receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        fulfill(.failure(error))
                    case .finished:
                        ()
                    }
                }, receiveValue: { value in fulfill(.success(value)) })
                .store(in: &cancellables)
        }
    }

    public init(result: Result<Value, ErrorType>) {
        self.init { fulfill in
            fulfill(result)
        }
    }

    public init(value: Value) {
        self.init(result: .success(value))
    }

    public func attemptToMsg<Msg>(_ toMsg: @escaping (Result<Value, ErrorType>) -> Msg) -> Cmd<Msg> {
        .ofTask(toMsg: toMsg, work: work)
    }

    public func attemptToMsgOptional<Msg>(_ toMsgOptional: @escaping (Result<Value, ErrorType>) -> Msg?) -> Cmd<Msg> {
        .ofTask(toMsgOptional: toMsgOptional, work: work)
    }

    public func attemptToCmd<Msg>(_ toCmd: @escaping (Result<Value, ErrorType>) -> Cmd<Msg>) -> Cmd<Msg> {
        .ofTask(toCmd: toCmd, work: work)
    }

    public static func attemptToMsg<Msg>(_ toMsg: @escaping (Result<Value, ErrorType>) -> Msg) -> (Task<Value, ErrorType>) -> Cmd<Msg> {
        { task in
            .ofTask(
                toMsg: toMsg,
                work: task.work
            )
        }
    }

    public static func attemptToMsgOptional<Msg>(_ toMsgOptional: @escaping (Result<Value, ErrorType>) -> Msg?) -> (Task<Value, ErrorType>) -> Cmd<Msg> {
        { task in
            .ofTask(
                toMsgOptional: toMsgOptional,
                work: task.work
            )
        }
    }

    public static func attemptToCmd<Msg>(_ toCmd: @escaping (Result<Value, ErrorType>) -> Cmd<Msg>) -> (Task<Value, ErrorType>) -> Cmd<Msg> {
        { task in
            .ofTask(toCmd: toCmd, work: task.work)
        }
    }

    public func flatMap<NewValue>(_ mapTask: @escaping (Value) -> Task<NewValue, ErrorType>) -> Task<NewValue, ErrorType> {
        Task<NewValue, ErrorType> { fulfill, cancellables in
            work({ [cancellables] (oldResult: Result<Value, ErrorType>) in
                     var cs = cancellables
                     switch oldResult {
                     case .success(let oldValue):
                         let mappedTask = mapTask(oldValue)
                         mappedTask.work(fulfill, &cs)
                     case .failure(let error):
                         fulfill(.failure(error))
                     }
                 }, &cancellables)
        }
    }

    public func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> Task<NewValue, ErrorType> {
        flatMap { value in
            Task<NewValue, ErrorType>(value: transform(value))
        }
    }
}

@available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where ErrorType == Never {
    public func setFailureType<E: Error>(to type: E.Type) -> Task<Value, E> {
        Task<Value, E> { fulfill, cancellables in
            self.work({ (oldResult: Result<Value, ErrorType>) in
                          switch oldResult {
                          case let .success(value):
                              fulfill(.success(value))
                          case .failure:
                              fatalError()
                          }
                      }, &cancellables)
        }
    }

    public func dematerialize<V, E>() -> Task<V, E> where Value == Result<V, E> {
        setFailureType(to: E.self).flatMap { (result: Result<V, E>) in
            Task<V, E> { fulfill in
                switch result {
                case let .success(v):
                    fulfill(.success(v))
                case let .failure(e):
                    fulfill(.failure(e))
                }
            }
        }
    }
}
