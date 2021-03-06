import XCTest
@testable import HealthDataProvider
import HealthKit
import Combine

final class AppleHealthStepFetchControllerTests: XCTestCase {
    
    var testQuery: AppleHealthFetchQuery {
        let startDate = Date(timeIntervalSince1970: 1)
        let endDate = Date(timeIntervalSince1970: 10)
        return AppleHealthFetchQuery(
            startDate: startDate,
            endDate: endDate,
            category: .dailyStepCount
        )
    }
    
    func testLifecycleManagement() {
        let query = testQuery
        let fetchController = AppleHealthStepFetchController(
            healthStore: HKHealthStore(),
            query: query
        )
        XCTAssertNil(fetchController.observerQuery)
        fetchController.startFetching()
        XCTAssertNotNil(fetchController.observerQuery)
        fetchController.stopFetching()
        XCTAssertNil(fetchController.observerQuery)        
    }
    
    func testInternalObserverQueryCreationMatchesQuery() {
        let query = testQuery
        let fetchController = AppleHealthStepFetchController(
            healthStore: HKHealthStore(),
            query: query
        )
        let observerQuery = fetchController.getObserverQueryForQuery(query)
        XCTAssertEqual(observerQuery.predicate, query.queryPredicate)
        XCTAssertEqual(observerQuery.objectType, query.queryObjectType)
    }
    
}
