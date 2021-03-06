//
//  UserGoalsService.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

/// This service is responsible to keep the local persistence store in sync with the server.
class UserGoalsService {
    
    let userGoalsRepository: UserGoalsRepository
    let userGoalsPersistence: UserGoalPersisting
    
    init(repository: UserGoalsRepository, persistence: UserGoalPersisting) {
        self.userGoalsRepository = repository
        self.userGoalsPersistence = persistence
    }
    
}
