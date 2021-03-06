//
//  RewardGenerator.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation

class RewardGenerator: RewardGenerating {
    func rewardForGoal(goal: GoalRewardable, progress: ProgressEvaluationResult) -> GoalReward? {
        switch progress {
        case .notStarted:
            return nil
        case .reached:
            return .init(points: goal.points, trophy: goal.trophy)
        case .inProgress:
            return nil
        }
    }
}
