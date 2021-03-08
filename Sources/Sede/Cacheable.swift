//
// Created by 和泉田 領一 on 2021/03/09.
//

import Foundation

public protocol Cacheable {
    static var identifier: String { get }
}

public extension Cacheable {
    static var identifier: String { String(describing: Self.self) }
}

private var cacheDictionary = [String: Any]()

func getInstanceOf<T: Cacheable>(_ type: T.Type, _ factory: () -> T) -> T {
    let key = T.identifier
    let cachedInstance = cacheDictionary[key]
    if let instance = cachedInstance as? T {
        debugPrint("Hit cache")
        return instance
    } else {
        debugPrint("Not hit cache")
        let instance = factory()
        cacheDictionary[key] = instance
        return instance
    }
}
