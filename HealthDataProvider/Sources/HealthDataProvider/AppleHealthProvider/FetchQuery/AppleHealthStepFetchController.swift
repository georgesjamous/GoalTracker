//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import HealthKit
import Combine

/// AppleHealthStepFetchController acts like NSResultFetchController
/// and is responsible to emit update of a health query
class AppleHealthStepFetchController {
    
    deinit {
        stopFetching()
    }
    
    let healthStore: HKHealthStore
    let trackedQuery: AppleHealthFetchQuery
    var observerQuery: HKObserverQuery?
    var cancellableSet: Set<AnyCancellable> = Set()
    
    var valueSubject = PassthroughSubject<Result<Int, Error>, Never>()
    var valuePublisher: AnyPublisher<Result<Int, Error>, Never> { valueSubject.eraseToAnyPublisher() }

    init(healthStore: HKHealthStore, query: AppleHealthFetchQuery) {
        self.healthStore = healthStore
        self.trackedQuery = query
    }
    
    // MARK: Fetching Controls
    
    /// Starts sending HK data updates
    /// Safe to be called multiple times
    func startFetching() {
        guard observerQuery == nil else { return }
        createObserverQuery()
        
        // lets get first result fast
        executeTrackedQuery()
    }
    
    func stopFetching() {
        if let observerQuery = self.observerQuery {
            healthStore.stop(observerQuery)
            self.observerQuery = nil
        }
    }
 
    // MARK: Internals
    
    func createObserverQuery() {
        assert(observerQuery == nil, "We shouldnt reach here without calling stopFetching first")
        observerQuery = getObserverQueryForQuery(trackedQuery)
        self.healthStore.execute(observerQuery!)
    }
    
    func getObserverQueryForQuery(_ query: AppleHealthFetchQuery) -> HKObserverQuery {
        HKObserverQuery(
            sampleType: query.queryObjectType,
            predicate: query.queryPredicate
        ) { [weak self] (oQuery, completion, error) in
            self?.dataChanged(query: oQuery, error: error)
            completion()
        }
    }
    
    func dataChanged(query: HKObserverQuery, error: Error?) {
        if let error = error {
            self.valueSubject.send(.failure(error))
        } else {
            executeTrackedQuery()
        }
    }
    
    func executeTrackedQuery() {
        trackedQuery.performQuery(healthStore: healthStore)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.valueSubject.send(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (count) in
                self?.valueSubject.send(.success(count))
            }.store(in: &cancellableSet)
    }
}
