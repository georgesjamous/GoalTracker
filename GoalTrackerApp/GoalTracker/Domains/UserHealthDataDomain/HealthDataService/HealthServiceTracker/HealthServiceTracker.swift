//
//  HealthServiceTracker.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import HealthDataProvider
import Combine

/// HealthServiceTracker is responsible to pull
/// data from the health repository and store it in the persistence.
class HealthServiceTracker {
    
    deinit {
        precondition(!isFetching, "Stop fetching first")
    }
    
    private var cancellableSet = Set<AnyCancellable>()
    private(set) var isFetching: Bool = false
    
    let date: Date
    let repository: HealthDataRepository
    let persistence: HealthDataPersisting
    let queue = DispatchQueue(label: "com.domain.HealthServiceTracker", target: .tracker)

    init(date: Date, repository: HealthDataRepository, persistence: HealthDataPersisting) {
        self.date = date
        self.repository = repository
        self.persistence = persistence
        self.bindToRepository()
    }
    
    // MARK: Internals
    
    private func bindToRepository() {
        repository
            .healthRecordPublisher
            .receive(on: queue)
            .sink { [weak self] (healthRecord) in
                self?.persistence.save(healthRecord: healthRecord)
            }.store(in: &cancellableSet)
    }
    
    func startFetching() {
        guard !isFetching else { return }
        isFetching = true
        
        repository.startFetching()
    }
    
    func stopFetching() {
        guard isFetching else { return }
        isFetching = false
        
        repository.stopFetching()
    }
    
}
