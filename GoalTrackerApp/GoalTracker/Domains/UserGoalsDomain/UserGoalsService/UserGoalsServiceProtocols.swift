//
//  UserGoalsServicing.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

/// Used to read data from the service
protocol UserGoalsServiceDataProviding {
    /// Returns a fetch controller for goals
    func fetchController(goalId: String?) -> GoalFetching
}

/// Used to write data to the service (mutations)
/// This in turn will update the persistence.
protocol UserGoalsServiceDataControlling {
    /// Refresh the user's goals list
    func refreshGoals() -> Future<Void, DomainError>
    /// Add a goal
    //   func addGoal() -> Future<Void, Error>
    /// Remove a goal
    //   func removeGoal() -> Future<Void, Error>
}
