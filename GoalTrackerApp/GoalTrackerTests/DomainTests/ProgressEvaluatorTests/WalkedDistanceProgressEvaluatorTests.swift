//
//  WalkGoalProgressEvaluatorTests.swift
//  GoalTrackerTests
//
//  Created by Georges on 3/5/21.
//

import XCTest
@testable import GoalTracker
import HealthDataProvider

class WalkedDistanceProgressEvaluatorTests: XCTestCase {
    
    func testProgressEvaluatedCorrectly() throws {
        let evaluator = WalkedDistanceProgressEvaluator()
        struct TestCase {
            let goal: Int
            let current: Int
            let expected: ProgressEvaluationResult
        }
        let tests: [TestCase] = [
            TestCase(goal: 0, current: 23, expected: .notStarted),
            TestCase(goal: 100, current: 10, expected: .inProgress(percentage: 0.1)),
            TestCase(goal: 100, current: 999, expected: .reached),
            TestCase(goal: -6, current: 23, expected: .notStarted),
            TestCase(goal: 222, current: -29, expected: .notStarted),
            TestCase(goal: 5000, current: 1500, expected: .inProgress(percentage: 0.3))
        ]
        tests.forEach { (tc) in
            let expectedProgress = evaluator.evaluateProgress(
                goalCriteria: .init(distance: tc.goal),
                progressCriteria: .init(distance: tc.current)
            )
            XCTAssertEqual(expectedProgress, tc.expected)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
