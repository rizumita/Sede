//
// Created by Ryoichi Izumita on 2021/03/07.
//

import SwiftUI

public protocol _Sowing {
    associatedtype Sede

    func sow(_ sede: Sede)
}

public protocol Sowing: _Sowing, SimpleFactory {}

public protocol EnvironmentalSowing: _Sowing, EnvironmentalFactory {}
