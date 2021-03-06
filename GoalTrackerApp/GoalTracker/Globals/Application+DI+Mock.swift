//
//  Application+DI+Mock.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import HealthDataProvider

extension Application {
    #if DEBUG
    /// this could be moved to another file
    func overrideDI() {
        if CommandLine.arguments.contains("-mock-health-data") {
            container.register(WalkingDistanceHealthDataProviding.self) { (_, start, end) -> WalkingDistanceHealthDataProviding in
                MockWalkingDistanceHealthRecordProvider(startDate: start, endDate: end)
            }
            container.register(RunningDistanceHealthDataProviding.self) { (_, start, end) -> RunningDistanceHealthDataProviding in
                MockRunningDistanceHealthRecordProvider(startDate: start, endDate: end)
            }
            container.register(StepHealthDataProviding.self) { (_, start, end) -> StepHealthDataProviding in
                MockStepHealthRecordProvider(startDate: start, endDate: end)
            }
            container.register(HealthDataRepository.self) { (_, date) -> HealthDataRepository in
                HealthDataRepository(date: date)
            }
        }
    }
    #endif
}
