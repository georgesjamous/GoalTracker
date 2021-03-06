//
//  DataPersisting.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

/// UserGoalPersisting is responsible for persisting goals on device.
/// And provide a way to access these changes.
protocol UserGoalPersisting {
    
    /// Replaces all saved goals
    /// todo:
    /// add the ability to replace a goal instead of replacing all the goals
    func saveGoals(_ goal: [Goal])
            
    /// A fetch controller for fetching goals.
    /// - Parameter goalId: if specified, the result will be tailored to one goal.
    func fetchController(goalId: String?) -> GoalFetching
    
}
