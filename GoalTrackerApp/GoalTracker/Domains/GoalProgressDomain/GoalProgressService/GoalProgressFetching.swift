//
//  GoalProgressFetching.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import CoreData
import Combine

protocol GoalProgressFetching {
    /// Returns all progress for goals
    var progressPublisher: AnyPublisher<[GoalProgress], Never> { get }
    /// Returns only the progess that changed
    var changedProgressPublisher: AnyPublisher<[GoalProgress], Never> { get }
    /// Start fetching
    func startFetching()
    // Stops the fetch process
    func stopFetching()
    
}
