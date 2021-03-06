//
//  File.swift
//  
//
//  Created by Georges on 3/5/21.
//

import Foundation
import Combine
import HealthKit

public class AppleDistanceRunningHealthProvider {
    
    let startDate: Date
    let endDate: Date
    let subject = PassthroughSubject<RunningDistanceHealthRecordInterface, Never>()
    let healthStore = HKHealthStore()
    
    var fetchController: AppleHealthStepFetchController?
    var cancellableSet: Set<AnyCancellable> = Set()
    
    public required init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension AppleDistanceRunningHealthProvider: RunningDistanceHealthDataProviding {
    public var recordPublisher: AnyPublisher<RunningDistanceHealthRecordInterface, Never> {
        subject.eraseToAnyPublisher()
    }
    public func startLoadingRecords() {
        stopLoadingRecords()
        fetchController = AppleHealthStepFetchController(
            healthStore: healthStore,
            query: .init(startDate: startDate, endDate: endDate, category: .dailyDistanceWalked)
        )
        fetchController?.valuePublisher.sink(receiveValue: { [weak self] (value) in
            guard let self = self else { return }
            switch value {
            case .failure: break
                // TODO: send error to a seperate publisher
            case .success(let count):
                self.subject.send(RunningDistanceHealthRecord(id: UUID(), date: self.startDate, distanceInMeters: count))
            }
        }).store(in: &cancellableSet)
        fetchController?.startFetching()
    }
    public func stopLoadingRecords() {
        fetchController?.stopFetching()
        fetchController = nil
    }
}

