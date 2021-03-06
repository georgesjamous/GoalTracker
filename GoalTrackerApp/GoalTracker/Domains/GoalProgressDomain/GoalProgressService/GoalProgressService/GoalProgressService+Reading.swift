//
//  GoalProgressService+Reading.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation
import Combine

extension GoalProgressService: GoalProgressServiceDataProviding {
    func fetchController(date: Date, goalId: String?) -> GoalProgressFetching {
        persistence.fetchController(date: date, goalId: goalId)
    }
    func progressTracker(date: Date, goalId: String?) -> GoalProgressTracker {
        return GoalProgressTracker(
            goalFetching: goalDataProvider.fetchController(goalId: goalId),
            healthRecordFetching: healthDataProvider.fetchController(date: date),
            progressPersisting: persistence
        )
    }
}
