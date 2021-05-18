//
//  SedeMemoApp.swift
//  SedeMemo
//
//  Created by Ryoichi Izumita on 2021/03/10.
//

import SwiftUI
import Sede

@main
struct SedeMemoApp: App {
    var router = SedeMemoRouter()

    var body: some Scene {
        WindowGroup {
            router.base(.editor).environmentObject(MemoStore())
        }
    }
}
