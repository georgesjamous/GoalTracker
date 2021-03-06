//
//  UserTrophyService.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

class GoalProgressService {

    let goalDataProvider: UserGoalsServiceDataProviding
    let healthDataProvider: HealthDataServiceDataProviding
    let persistence: GoalProgressPersisting
    
    private var cancellableSet = Set<AnyCancellable>()
        
    init(
        persistence: GoalProgressPersisting,
        goalDataProvider: UserGoalsServiceDataProviding,
        healthDataProvider: HealthDataServiceDataProviding
    ) {
        self.persistence = persistence
        self.goalDataProvider = goalDataProvider
        self.healthDataProvider = healthDataProvider        
    }
    
}




