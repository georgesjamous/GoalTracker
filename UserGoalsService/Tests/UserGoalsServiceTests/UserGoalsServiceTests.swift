import XCTest
@testable import UserGoalsService

final class UserGoalsServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UserGoalsService().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
