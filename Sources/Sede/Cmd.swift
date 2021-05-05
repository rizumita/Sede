//
//  Cmd.swift
//  
//
//  Created by 和泉田 領一 on 2021/05/05.
//

import Foundation

public typealias Dispatch<Msg> = (Msg) -> ()
public typealias Sub<Msg> = (@escaping Dispatch<Msg>) -> ()

@available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct Cmd<Msg> {
    let value: [Sub<Msg>]

    public static var none: Cmd<Msg> { Cmd<Msg>(value: []) }

    public static func ofMsg(_ msg: Msg) -> Cmd<Msg> {
        Cmd(value: [{ dispatch in dispatch(msg) }])
    }

    public static func ofMsgOptional(_ msg: Msg?) -> Cmd<Msg> {
        Cmd(value: [{ dispatch in msg.map(dispatch) }])
    }

    public static func map<A>(_ f: @escaping (A) -> Msg) -> (Cmd<A>) -> Cmd<Msg> {
        { cmd in
            Cmd<Msg>(value: cmd.value.map { sub in
                { dispatch in sub { a in dispatch(f(a)) } }
            })
        }
    }

    public func map<B>(_ f: @escaping (Msg) -> B) -> Cmd<B> {
        Cmd<B>.map(f)(self)
    }

    public static func batch(_ cmds: [Cmd<Msg>]) -> Cmd<Msg> {
        Cmd(value: cmds.flatMap { cmd in cmd.value })
    }

    public static func ofSub(_ sub: @escaping Sub<Msg>) -> Cmd<Msg> {
        Cmd(value: [sub])
    }

    public static func dispatch(_ dispatch: @escaping Dispatch<Msg>) -> (Cmd<Msg>) -> () {
        { cmd in cmd.value.forEach { (sub: Sub<Msg>) in sub(dispatch) } }
    }

    public func dispatch(_ dispatch: @escaping Dispatch<Msg>) {
        Cmd.dispatch(dispatch)(self)
    }

    public static func ofAsyncMsg(_ async: @escaping (@escaping (Msg) -> ()) -> ()) -> Cmd<Msg> {
        Cmd(value: [{ dispatch in
            async { msg in
                dispatch(msg)
            }
        }])
    }

    public static func ofAsyncMsgOptional(_ async: @escaping (@escaping (Msg?) -> ()) -> ()) -> Cmd<Msg> {
        Cmd(value: [{ dispatch in
            async { msg in
                guard let msg = msg else { return }
                dispatch(msg)
            }
        }])
    }

    public static func ofAsyncCmd(_ async: @escaping (@escaping (Cmd<Msg>) -> ()) -> ()) -> Cmd<Msg> {
        Cmd(value: [{ dispatch in
            async { cmd in
                cmd.dispatch(dispatch)
            }
        }])
    }

    public static func ofAsyncCmdOptional(_ async: @escaping (@escaping (Cmd<Msg>?) -> ()) -> ()) -> Cmd<Msg> {
        Cmd(value: [{ dispatch in
            async { cmd in
                guard let cmd = cmd else { return }
                cmd.dispatch(dispatch)
            }
        }])
    }
}
