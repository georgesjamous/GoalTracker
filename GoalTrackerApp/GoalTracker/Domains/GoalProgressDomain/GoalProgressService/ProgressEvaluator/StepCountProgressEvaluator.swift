//
//  StepGoalProgressEvaluating.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation

class StepCountProgressEvaluator: ProgressEvaluating {
    struct GoalCriterial: ProgressEvaluatableGoalCriteria {
        let stepCount: Int
    }
    struct ProgressCriteria: ProgressEvaluatableCriteria {
        let stepCount: Int
    }
    func evaluateProgress(goalCriteria: GoalCriterial, progressCriteria: ProgressCriteria) -> ProgressEvaluationResult {
        guard goalCriteria.stepCount > 0 else { return .notStarted }
        guard progressCriteria.stepCount >= 0 else { return .notStarted }
        let percentage = Double(progressCriteria.stepCount) / Double(goalCriteria.stepCount)
        if percentage <= 0 {
            return .notStarted
        } else if percentage >= 1 {
            return .reached
        } else {
            return .inProgress(percentage: percentage)
        }
    }
}
