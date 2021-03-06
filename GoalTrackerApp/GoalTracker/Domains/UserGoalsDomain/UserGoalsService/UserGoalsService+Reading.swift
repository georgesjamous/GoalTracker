//
//  UserGoalsService+Data.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation
import Combine

extension UserGoalsService: UserGoalsServiceDataProviding {
    func fetchController(goalId: String?) -> GoalFetching {
        userGoalsPersistence.fetchController(goalId: goalId)
    }
}
