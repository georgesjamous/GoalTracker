//
//  RewardGenerating.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation

protocol RewardGenerating {
    func rewardForGoal(goal: GoalRewardable, progress: ProgressEvaluationResult) -> GoalReward?
}
