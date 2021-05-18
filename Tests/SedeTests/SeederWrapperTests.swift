//
//  AnySeederTests.swift
//  
//
//  Created by Ryoichi Izumita on 2021/05/07.
//

import XCTest
@testable import Sede

final class SeederWrapperTests: XCTestCase {
    struct TestSeeder<Model, Msg>: Seedable {
        let injectedInitialized: () -> (Model, Cmd<Msg>)
        let injectedReceive:     (Model, Msg) -> ()

        func initialize() -> (Model, Cmd<Msg>) { injectedInitialized() }

        func receive(model: Model, msg: Msg) { injectedReceive(model, msg) }
    }

    func testUpdateCyclically() {
        XCTContext.runActivity(named: "Model: Never, Msg: Never") { _ in
            let seeder = SeederWrapper(seeder: TestSeeder<Never, Never>(injectedInitialized: { fatalError() },
                                                                    injectedReceive: { _, _ in }))
            seeder.updateCyclically()
        }
    }

    static var allTests = [
        ("testUpdateCyclically", testUpdateCyclically)
    ]
}
