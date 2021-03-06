//
//  GoalProgressServiceProtocols.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation
import Combine

/// Used to read data from the service
protocol GoalProgressServiceDataProviding {
    /// Returns a fetch controller for goal progress.
    /// - Parameters:
    ///   - date: the specific date
    ///   - goalId: if specicied, will be limited to on goal
    func fetchController(date: Date, goalId: String?) -> GoalProgressFetching
    /// Returns a goal profgress tracker
    func progressTracker(date: Date, goalId: String?) -> GoalProgressTracker
}

/// Used to write data to the service (mutations)
protocol GoalProgressServiceControlling {}
