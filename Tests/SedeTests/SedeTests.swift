import XCTest
@testable import Sede

final class SedeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Sede().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
