//
//  HealthKitPermissions.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import HealthKit

/// simple HealthKitPermissions permission checker
class HealthKitPermissions {
    enum PermissionStatus {
        case notAvailable
        case dataNotAvailable
        case authorized
        case notAuthorized(Error?)
    }
    func requestPermission(_ completion: @escaping (PermissionStatus) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.notAvailable)
            return
        }
        guard
            let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let walkingDistance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else {
            completion(.dataNotAvailable)
            return
        }
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount, walkingDistance]
        HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead, completion: { (ok, error) in
            if ok && error == nil {
                completion(.authorized)
            } else {
                completion(.notAuthorized(error))
            }
        })
    }
}
