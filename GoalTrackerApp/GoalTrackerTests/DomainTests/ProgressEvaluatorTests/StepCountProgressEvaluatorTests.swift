//
//  StepsGoalProgressEvaluatorTests.swift
//  GoalTrackerTests
//
//  Created by Georges on 3/5/21.
//

import XCTest
@testable import GoalTracker
import HealthDataProvider

class StepCountProgressEvaluatorTests: XCTestCase {
    func testProgressEvaluatedCorrectly() throws {
        let evaluator = StepCountProgressEvaluator()
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
                goalCriteria: .init(stepCount: tc.goal),
                progressCriteria: .init(stepCount: tc.current)
            )
            XCTAssertEqual(expectedProgress, tc.expected)
        }
    }
}
