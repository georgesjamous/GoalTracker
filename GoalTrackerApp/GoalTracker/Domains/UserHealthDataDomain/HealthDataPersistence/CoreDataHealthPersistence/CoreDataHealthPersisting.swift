//
//  CoreDataHealthPersisting.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine
import CoreData

class CoreDataHealthPersisting {
    
    private var cancellableSet: Set<AnyCancellable> = Set()
    private var goalsChangedSubject = PassthroughSubject<[Goal], Never>()
    private let stack: HealthCoreDataPersistingStack
    
    init(stack: HealthCoreDataPersistingStack) {
        self.stack = stack
    }
    
}

extension CoreDataHealthPersisting: HealthDataPersisting {
    func save(healthRecord: HealthRecord) -> Future<Void, Error> {
        stack.updateHealthRecord(record: healthRecord)
    }
    func fetchController(date: Date) -> HealthRecordFetching {
        stack.healthFetchController(date: date)
    }
}
