//
//  GoalProgressEvaluating.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation

enum ProgressEvaluationResult: Equatable {
    case reached
    case notStarted
    /// percentage is from 0 to 1
    case inProgress(percentage: Double)
}

/// Goal specific criteria for evaluation
protocol ProgressEvaluatableCriteria {}

/// Goal specific criteria for evaluation
protocol ProgressEvaluatableGoalCriteria {}

/// An evaluator that evaluates a goal and spits out a progress state
protocol ProgressEvaluating {
    associatedtype T: ProgressEvaluatableGoalCriteria
    associatedtype E: ProgressEvaluatableCriteria
    func evaluateProgress(goalCriteria: T, progressCriteria: E) -> ProgressEvaluationResult
}
