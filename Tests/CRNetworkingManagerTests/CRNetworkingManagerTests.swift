import XCTest
@testable import CRNetworkingManager

final class CRNetworkingManagerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CRNetworkingManager().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
