//
//  HealthDataRepository.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import HealthDataProvider
import Combine

/// HealthDataRepository is responsible to listen
/// to changes from the health data provider, combine them and
/// return them to listeners.
class HealthDataRepository {
    
    deinit {
        precondition(!isFetching, "stop fetch first")
    }
        
    init(date: Date) {
        self.date = date
        self.bindToProviders()
    }
    
    let date: Date
    private var cancellableSet = Set<AnyCancellable>()
    private(set) var isFetching: Bool = false
    let queue = DispatchQueue(label: "com.domain.HealthDataRepository", target: .repository)
    var healthRecordPublisher: PassthroughSubject<HealthRecord, Never> = PassthroughSubject()
    
    //
    // Note:
    // we usually dont access the container using shared Application but send
    // it to the module. This is to speed up things.
    lazy var stepProvider = Application.shared.container.resolve(
        StepHealthDataProviding.self,
        arguments: date.startDateInCalendar, date.endDateInCalendar
    )!
    lazy var walkingDistanceProvider = Application.shared.container.resolve(
        WalkingDistanceHealthDataProviding.self,
        arguments: date.startDateInCalendar, date.endDateInCalendar
    )!
    lazy var runningDistanceProvider = Application.shared.container.resolve(
        RunningDistanceHealthDataProviding.self,
        arguments: date.startDateInCalendar, date.endDateInCalendar
    )!
    
    func startFetching() {
        guard !isFetching else { return }
        isFetching = true
        
        stepProvider.startLoadingRecords()
        walkingDistanceProvider.startLoadingRecords()
        runningDistanceProvider.startLoadingRecords()
    }
    
    func stopFetching() {
        guard isFetching else { return }
        
        stepProvider.stopLoadingRecords()
        walkingDistanceProvider.stopLoadingRecords()
        runningDistanceProvider.stopLoadingRecords()
    
        isFetching = false
    }
    
    // MARK: Internal
    
    //
    private func bindToProviders() {
        Publishers.CombineLatest3(
            stepProvider.recordPublisher,
            walkingDistanceProvider.recordPublisher,
            runningDistanceProvider.recordPublisher
        )
        // Since we are dependet on an external data source,
        // and we dont know the reponse frequency.
        // To prevent verry frequent calls, lets throttle this to return .subsecon results.
        .throttle(for: .milliseconds(500), scheduler: queue, latest: true)
        .sink { [weak self] (steps, walked, ran) in
            self?.updateRecord(
                steps: steps.stepCount,
                walked: walked.distanceInMeters,
                ran: ran.distanceInMeters
            )
        }.store(in: &cancellableSet)
    }
    
    private func updateRecord(steps: Int, walked: Int, ran: Int) {
        healthRecordPublisher.send(
            .init(
                date: date,
                steps: steps,
                distanceWalked: walked,
                distanceRan: ran
            )
        )
    }
    
}
