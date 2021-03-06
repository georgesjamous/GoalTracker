//
//  WalkedDistance.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation

class WalkedDistanceProgressEvaluator: ProgressEvaluating {
    struct GoalCriterial: ProgressEvaluatableGoalCriteria {
        let distance: Int
    }
    struct ProgressCriteria: ProgressEvaluatableCriteria {
        let distance: Int
    }
    func evaluateProgress(goalCriteria: GoalCriterial, progressCriteria: ProgressCriteria) -> ProgressEvaluationResult {
        guard goalCriteria.distance > 0 else { return .notStarted }
        guard progressCriteria.distance >= 0 else { return .notStarted }
        let percentage = Double(progressCriteria.distance) / Double(goalCriteria.distance)
        if percentage <= 0 {
            return .notStarted
        } else if percentage >= 1 {
            return .reached
        } else {
            return .inProgress(percentage: percentage)
        }
    }
}
