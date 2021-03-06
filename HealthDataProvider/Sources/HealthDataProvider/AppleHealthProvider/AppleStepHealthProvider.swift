//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine
import HealthKit

public class AppleStepHealthProvider {
        
    let startDate: Date
    let endDate: Date
    let subject = PassthroughSubject<StepHealthRecordInterface, Never>()
    let healthStore = HKHealthStore()
    
    var fetchController: AppleHealthStepFetchController?
    var cancellableSet: Set<AnyCancellable> = Set()

    public required init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension AppleStepHealthProvider: StepHealthDataProviding {
    public var recordPublisher: AnyPublisher<StepHealthRecordInterface, Never> {
        subject.eraseToAnyPublisher()
    }
    public func startLoadingRecords() {
        stopLoadingRecords()
        fetchController = AppleHealthStepFetchController(
            healthStore: healthStore,
            query: .init(startDate: startDate, endDate: endDate, category: .dailyStepCount)
        )
        fetchController?.valuePublisher.sink(receiveValue: { [weak self] (value) in
            guard let self = self else { return }
            switch value {
            case .failure: break
                // TODO: send error to a seperate publisher
            case .success(let count):
                self.subject.send(StepHealthRecord(id: UUID(), date: self.startDate, stepCount: count))
            }
        }).store(in: &cancellableSet)
        fetchController?.startFetching()
    }
    public func stopLoadingRecords() {
        fetchController?.stopFetching()
        fetchController = nil
    }
}

