//
//  GoalRecrod.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import Combine

protocol GoalFetching {
    /// Publishes all the udates goals
    var goalsPublisher: AnyPublisher<[Goal], Never> { get }
    /// Only publishes the goals that have removed. todo
    var removedGoalsPublisher: AnyPublisher<[Goal], Never> { get }
    /// Only publishes the goals that have added. todo
    var addedGoalsPublisher: AnyPublisher<[Goal], Never> { get }
    /// Only publishes the goals that have been modified. todo
    var changedGoalsPublisher: AnyPublisher<[Goal], Never> { get }
    /// Begin continuous fetching
    func startFetching()
    /// End continuous fetching
    func stopFetching()
}
