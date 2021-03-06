//
//  HealthDataService.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import HealthDataProvider
import Combine

class HealthDataService {
    
    let persistence: HealthDataPersisting
    
    init(persistence: HealthDataPersisting) {
        self.persistence = persistence
    }
    
}
