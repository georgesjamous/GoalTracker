//
//  File.swift
//  
//
//  Created by Georges on 3/5/21.
//

import Foundation
import HealthKit
import Combine

// Note:
// we could also abstract this in protocol but we dont need that now
// protocol AppleHealthFetchQueryFetching {}

public class AppleHealthFetchQuery {
    
    public enum HealthCategory {
        case dailyStepCount
        case dailyDistanceWalked
        case dailyDistanceRan
        
        var hkType: HKQuantityType {
            switch self {
            case .dailyStepCount:
                return HKQuantityType.quantityType(forIdentifier: .stepCount)!
            case .dailyDistanceWalked,
                 .dailyDistanceRan:
                return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
            }
        }
    }
    
    let startDate: Date
    let endDate: Date
    let category: HealthCategory
    
    public init(startDate: Date, endDate: Date, category: HealthCategory) {
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
    }
    
    public func performQuery(healthStore: HKHealthStore) -> Future<Int, Error> {
        executeQuery(healthStore)
    }
    
    // MARK: Query Prefrences
    
    public var queryObjectType: HKQuantityType {
        category.hkType
    }
    
    public var queryPredicate: NSPredicate {
        HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: [.strictStartDate, .strictEndDate]
        )
    }
    
    private func healthQuery(completed: @escaping (Result<Int, Error>) -> ()) -> HKStatisticsQuery {
        HKStatisticsQuery(
            quantityType: queryObjectType,
            quantitySamplePredicate: queryPredicate,
            options: .cumulativeSum,
            completionHandler: { [weak self] (query, statistics, error) in
                guard let self = self else { return }
                let result = self.generateResult(statistics: statistics, error: error)
                completed(result)
            })
    }
    
    private func executeQuery(_ healthStore: HKHealthStore) -> Future<Int, Error> {
        Future { [weak self] response in
            guard let self = self else { return }
            let query = self.healthQuery { (result) in
                switch result {
                case .success(let count):
                    response(.success(count))
                case .failure(let error):
                    response(.failure(error))
                }
            }
            healthStore.execute(query)
        }
    }
    
    private func generateResult(statistics: HKStatistics?, error: Error?) -> Result<Int, Error> {
        if let error = error {
            if let err = error as? HKError {
                if #available(iOS 14.0, *), err.code == .errorNoData {
                    return .success(0)
                }
                if err.code == .noError {
                    return .success(0)
                }
            }
            return .failure(error)
        } else if let statistics = statistics, let quantity = statistics.sumQuantity() {
            let total = valueFromQuantity(quantity)
            return .success(total)
        } else {
            return .success(0)
        }
    }
    
    private func valueFromQuantity(_ quantity: HKQuantity) -> Int {
        switch category {
        case .dailyStepCount:
            return Int(quantity.doubleValue(for: HKUnit.count()))
        case .dailyDistanceWalked,
             .dailyDistanceRan:
            return Int(quantity.doubleValue(for: HKUnit.meter()))
        }
    }
}
