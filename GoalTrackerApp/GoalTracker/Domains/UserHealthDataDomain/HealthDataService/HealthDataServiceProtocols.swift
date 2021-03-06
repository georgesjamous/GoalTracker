//
//  HealthDataServicing.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

protocol HealthDataServiceDataProviding {
    
    /// Return a fetch controller for data at specific date.
    func fetchController(date: Date) -> HealthRecordFetching
    
    func healthRecordsTracker(date: Date) -> HealthServiceTracker
}

protocol HealthDataServiceDataControlling {}
