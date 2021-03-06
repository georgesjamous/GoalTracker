//
//  HealthDataService+Reading.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation
import Combine

extension HealthDataService: HealthDataServiceDataProviding {
    func fetchController(date: Date) -> HealthRecordFetching {
        persistence.fetchController(date: date)
    }
    func healthRecordsTracker(date: Date) -> HealthServiceTracker {
        HealthServiceTracker(
            date: date,
            repository: Application.container.resolve(HealthDataRepository.self, argument: date)!,
            persistence: persistence
        )
    }
}
