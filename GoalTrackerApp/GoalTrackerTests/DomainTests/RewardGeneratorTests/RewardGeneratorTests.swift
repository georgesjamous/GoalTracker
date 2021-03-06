//
//  RewardGeneratorTests.swift
//  GoalTrackerTests
//
//  Created by Georges on 3/5/21.
//

import XCTest
@testable import GoalTracker
import HealthDataProvider

class RewardGeneratorTests: XCTestCase {
    func testRewardGeneratedCorrectly() throws {
        let evaluator = RewardGenerator()
        struct Reward: GoalRewardable {
            var trophy: RewardTrophy
            var points: Int
        }
        struct TestCase {
            let rewardable: GoalRewardable
            let progress: ProgressEvaluationResult
            let expected: GoalReward?
        }
        let tests: [TestCase] = [
            TestCase(
                rewardable: Reward(trophy: .bronzeMedal, points: 100),
                progress: .notStarted,
                expected: nil
            ),
            TestCase(
                rewardable: Reward(trophy: .bronzeMedal, points: 100),
                progress: .inProgress(percentage: 100),
                expected: nil
            ),
            TestCase(
                rewardable: Reward(trophy: .bronzeMedal, points: 100),
                progress: .reached,
                expected: .init(points: 100, trophy: .bronzeMedal)
            ),
            TestCase(
                rewardable: Reward(trophy: .goldMedal, points: 1234),
                progress: .reached,
                expected: .init(points: 1234, trophy: .goldMedal)
            )
        ]
        tests.forEach { (tc) in
            let expectedResult = evaluator.rewardForGoal(
                goal: tc.rewardable,
                progress: tc.progress
            )
            XCTAssertEqual(expectedResult, tc.expected)
        }
    }
}
