//
//  Cmd.swift
//  
//
//  Created by Ryoichi Izumita on 2021/05/05.
//

import Foundation
import Combine

public typealias Dispatch<Msg> = (Msg) -> ()

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias Sub<Msg> = (@escaping Dispatch<Msg>, inout Set<AnyCancellable>) -> ()

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct Cmd<Msg> {
    let value: [Sub<Msg>]

    public static var none: Cmd<Msg> { Cmd<Msg>(value: []) }

    public static func ofMsg(_ msg: Msg) -> Cmd<Msg> {
        Cmd(value: [{ dispatch, _ in dispatch(msg) }])
    }

    public static func ofMsgOptional(_ msg: Msg?) -> Cmd<Msg> {
        Cmd(value: [{ dispatch, _ in msg.map(dispatch) }])
    }

    public static func map<A>(_ f: @escaping (A) -> Msg) -> (Cmd<A>) -> Cmd<Msg> {
        { cmd in
            Cmd<Msg>(value: cmd.value.map { sub in
                { dispatch, cancellables in
                    sub({ a in dispatch(f(a)) }, &cancellables)
                }
            })
        }
    }

    public func map<B>(_ f: @escaping (Msg) -> B) -> Cmd<B> {
        Cmd<B>.map(f)(self)
    }

    public static func batch(_ cmds: [Cmd<Msg>]) -> Cmd<Msg> {
        Cmd(value: cmds.flatMap { cmd in cmd.value })
    }

    public static func batch(_ cmds: Cmd<Msg>...) -> Cmd<Msg> {
        Cmd(value: cmds.flatMap { cmd in cmd.value })
    }

    public static func ofSub(_ sub: @escaping Sub<Msg>) -> Cmd<Msg> {
        Cmd(value: [sub])
    }

    static func dispatch(_ dispatch: @escaping Dispatch<Msg>) -> (Cmd<Msg>, inout Set<AnyCancellable>) -> () {
        { cmd, cancellables in
            cmd.value.forEach { (sub: Sub<Msg>) in sub(dispatch, &cancellables) }
        }
    }

    func dispatch(_ dispatch: @escaping Dispatch<Msg>, cancellables: inout Set<AnyCancellable>) {
        Cmd.dispatch(dispatch)(self, &cancellables)
    }

    public static func ofAsyncMsg(_ async: @escaping (@escaping (Msg) -> ()) -> ()) -> Cmd<Msg> {
        Cmd(value: [{ dispatch, _ in
            async { msg in
                dispatch(msg)
            }
        }])
    }

    public static func ofAsyncMsgOptional(_ async: @escaping (@escaping (Msg?) -> ()) -> ()) -> Cmd<Msg> {
        Cmd(value: [{ dispatch, _ in
            async { msg in
                guard let msg = msg else { return }
                dispatch(msg)
            }
        }])
    }

    public static func ofAsyncCmd(_ async: @escaping (@escaping (Cmd<Msg>) -> ()) -> ()) -> Cmd<Msg> {
        Cmd(value: [{ dispatch, cancellables in
            async { [cancellables] cmd in
                var cs = cancellables
                cmd.dispatch(dispatch, cancellables: &cs)
            }
        }])
    }

    public static func ofAsyncCmdOptional(_ async: @escaping (@escaping (Cmd<Msg>?) -> ()) -> ()) -> Cmd<Msg> {
        Cmd(value: [{ dispatch, cancellables in
            async { [cancellables] cmd in
                guard let cmd = cmd else { return }
                var cs = cancellables
                cmd.dispatch(dispatch, cancellables: &cs)
            }
        }])
    }

    static func ofTask<Value, ErrorType: Swift.Error>(toMsg: @escaping (Result<Value, ErrorType>) -> Msg,
                                                      work: @escaping Task<Value, ErrorType>.Work) -> Cmd<Msg> {
        Cmd(
            value: [
                { dispatch, cancellables in
                    work({ result in
                             let msg = toMsg(result)
                             dispatch(msg)
                         }, &cancellables)
                }
            ]
        )
    }

    static func ofTask<Value, ErrorType: Swift.Error>(toMsgOptional: @escaping (Result<Value, ErrorType>) -> Msg?,
                                                      work: @escaping Task<Value, ErrorType>.Work) -> Cmd<Msg> {
        Cmd(value: [
            { dispatch, cancellables in
                work({ result in
                         toMsgOptional(result).map(dispatch)
                     }, &cancellables)
            }
        ])
    }

    static func ofTask<Value, ErrorType: Swift.Error>(toCmd: @escaping (Result<Value, ErrorType>) -> Cmd<Msg>,
                                                      work: @escaping Task<Value, ErrorType>.Work) -> Cmd<Msg> {
        Cmd(value: [
            { dispatch, cancellables in
                work({ [cancellables] result in
                         let cmd = toCmd(result)
                         var cs = cancellables
                         cmd.dispatch(dispatch, cancellables: &cs)
                     }, &cancellables)
            }
        ]
        )
    }
}
