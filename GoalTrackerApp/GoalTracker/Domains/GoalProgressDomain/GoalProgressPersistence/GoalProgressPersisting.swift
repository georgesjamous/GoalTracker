//
//  GoalProgressPersisting.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation
import Combine

protocol GoalProgressPersisting {
    
    /// persists a set of goal progresses
    func saveGoalProgress(_ goal: [GoalProgress])
    
    /// returns a fetch controller that fetches a specific goal progress for a date
    /// - Parameters:
    ///   - date: the date to fetch for
    ///   - goalId: when set, restricts to goal
    func fetchController(date: Date, goalId: String?) -> GoalProgressFetching

}
