import XCTest
@testable import HealthDataProvider
import HealthKit
import Combine

final class AppleHealthFetchQueryTests: XCTestCase {
        
    func testQueryConfiguration() {
        let startDate = Date(timeIntervalSince1970: 1)
        let endDate = Date(timeIntervalSince1970: 10)
        let expectedPredicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: [.strictStartDate, .strictEndDate]
        )
        let fetchQuery = AppleHealthFetchQuery(
            startDate: startDate,
            endDate: endDate,
            category: .dailyStepCount
        )
        XCTAssertNotEqual(startDate, endDate)
        XCTAssertEqual(fetchQuery.startDate, startDate)
        XCTAssertEqual(fetchQuery.endDate, endDate)
        XCTAssertEqual(fetchQuery.category, .dailyStepCount)
        XCTAssertEqual(fetchQuery.queryPredicate, expectedPredicate)
    }
    
}
