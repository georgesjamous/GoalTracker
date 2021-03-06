//
//  HealthDataPersisting.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

/// HealthDataPersisting is responsible for persisting health data.
protocol HealthDataPersisting {
    
    /// Return a fetch controller for data at specific date.
    /// Data will be returned on a Daily basis, using current calendar.
    func fetchController(date: Date) -> HealthRecordFetching
    
    /// Save a health record element
    @discardableResult
    func save(healthRecord: HealthRecord) -> Future<Void, Error>
    
}
